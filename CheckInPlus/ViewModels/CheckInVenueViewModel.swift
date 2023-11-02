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
    @Published private(set) var venues: [Venue] = []
    @Published private(set) var venueError: NetworkResponseError?
    @Published var hasError = false
    @Published var checkInSuccess = false

    private var cancellables = Set<AnyCancellable>()
    private let locationManager = LocationManager()
    private let foursquareAPI = FoursquareAPIManager()

    init() {
        setupSubscribers()
    }

    func setupSubscribers() {
        locationManager.$currentLocation
            .sink { [weak self] location in
                guard let location else { return }
                self?.loadData(at: location)
                self?.locationManager.stopScanning()
            }
            .store(in: &cancellables)
    }

    var isCurrentlyLoggedIn: Bool {
        foursquareAPI.currentFoursquareAuthToken != nil
    }

    func loadData(at location: (latitude: Double, longitude: Double)) {
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

    func searchResults(searchText: String) -> [Venue] {
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespaces)
        guard !trimmedSearchText.isEmpty else { return venues }

        let smartSearchMatcher = SmartSearchMatcher(searchString: trimmedSearchText)

        let searchResults = venues.filter { venue in
            if smartSearchMatcher.searchTokens.count == 1,
               smartSearchMatcher.matches(venue.name) {
                return true
            }

            return smartSearchMatcher.matches(venue.name)
        }

        return searchResults
    }
}
