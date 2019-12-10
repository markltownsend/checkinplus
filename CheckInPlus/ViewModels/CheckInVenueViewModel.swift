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

public final class CheckInVenueViewModel: ObservableObject {

    @Published var venues: [Venue] = []
    @Published var venueError: String = ""
    
    private let locationManager = LocationManager()
    private let foursquareAPI = FoursquareAPIManager()

    init() {
        NotificationCenter.default.addObserver(forName: Notification.Name.CurrentLocationDidUpdateNotification, object: nil, queue: .main) { [weak self] (_) in
            guard let self = self else { return }
            self.loadData()
        }

    }
    func loadData() {
        guard let currentLocation = locationManager.currentLocation else { return }
        
        foursquareAPI.getCheckInVenues(latitude: currentLocation.latitude, longitude: currentLocation.longitude) { [weak self] (venues, error) in
            guard let self = self else { return }

            if let error = error {
                self.venueError = error
                return
            }

            if let venues = venues {
                DispatchQueue.main.async {
                    self.venues = venues.sorted(by: { (first, second) -> Bool in
                        first.location?.distance ?? 0 > second.location?.distance ?? 0
                    })
                }
            }
        }
    }
}
