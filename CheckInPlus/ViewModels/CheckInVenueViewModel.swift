//
//  CheckInVenueViewModel.swift
//  CheckInPlus
//
//  Created by Mark Townsend on 12/9/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import Combine
import Foundation
import FoursquareAPI
import NetworkLayer

@MainActor
final class CheckInVenueViewModel: ObservableObject {
    private(set) var venues: [Venue] = [] {
        didSet {
            searchResults = venues
        }
    }
    @Published private(set) var venueError: NetworkResponseError?
    @Published var hasError = false
    @Published private(set) var checkInSuccess = false
    @Published var noSearchResults = false
    @Published var searchResults: [Venue] = []

    private var cancellables = Set<AnyCancellable>()
    private let locationManager = LocationManager()
    private let foursquareAPI = FoursquareAPIManager()

    init(_ showNoResults: Bool = false) {
        guard !showNoResults
        else {
            noSearchResults = showNoResults
            return
        }

        setupSubscribers()
    }

    private func setupSubscribers() {
        locationManager.$currentLocation
            .sink { [weak self] location in
                guard let location else { return }
                self?.loadData(at: location)
                self?.locationManager.stopScanning()
            }
            .store(in: &cancellables)
    }

    var isCurrentlyLoggedIn: Bool {
        foursquareAPI.currentAuthToken != nil
    }

    private func loadData(at location: (latitude: Double, longitude: Double)) {
        Task {
            do {
                guard let venues = try await foursquareAPI.getCheckInVenues(latitude: location.latitude, longitude: location.longitude) else { return }
                hasError = false
                self.venues = venues.sorted(by: { first, second -> Bool in
                    first.location?.distance ?? 0 < second.location?.distance ?? 0
                })
            } catch let error as NetworkResponseError {
                venueError = error
                hasError = true
            }
        }
    }

    func checkIn(venueId: String, shout: String?) throws {
        Task { try await foursquareAPI.addCheckin(venueId: venueId, shout: shout) }
    }

    func searchResults(searchText: String) {
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespaces)
        guard !trimmedSearchText.isEmpty else {
            searchResults = venues
            return
        }

        let smartSearchMatcher = SmartSearchMatcher(searchString: trimmedSearchText)

        let searchResults = venues.filter { venue in
            if smartSearchMatcher.searchTokens.count == 1,
               smartSearchMatcher.matches(venue.name) {
                return true
            }

            return smartSearchMatcher.matches(venue.name)
        }
        
        noSearchResults = searchResults.isEmpty
        self.searchResults = searchResults
    }
}
