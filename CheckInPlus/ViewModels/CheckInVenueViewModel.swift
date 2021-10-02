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

final class CheckInVenueViewModel: ObservableObject {
  
  @Published private(set) var venues: [Venue] = []
  @Published private(set) var venueError: String = ""
  @Published var hasError = false
  @Published var checkInSuccess = false

  private var cancellables = Set<AnyCancellable>()
  private let locationManager = LocationManager()
  private let foursquareAPI = FoursquareAPIManager()

  init() {  }

  func refreshData() {
    locationManager.startScanning()
    locationManager.$currentLocation
      .sink { [weak self] location in
        guard let location = location else { return }
        self?.loadData(at: location)
      }
      .store(in: &cancellables)
  }

  func loadData(at location: (latitude: Double, longitude: Double)) {
    
    foursquareAPI.getCheckInVenues(latitude: location.latitude, longitude: location.longitude) { [weak self] (venues, error) in
      guard let self = self else { return }
      let queue = DispatchQueue.main
      queue.async {
        if let error = error {
          self.venueError = error
          self.hasError = true
          return
        }
        
        self.hasError = false
        if let venues = venues {
          self.venues = venues.sorted(by: { (first, second) -> Bool in
            first.location?.distance ?? 0 < second.location?.distance ?? 0
          })
          
        }
      }
    }
  }
  
  func checkIn(venueId: String, shout: String?, completion: @escaping (String?) -> Void) {
    
    foursquareAPI.addCheckin(venueId: venueId, shout: shout) { (error) in
      guard let error = error else {
        completion(nil)
        return
      }
      let queue = DispatchQueue.main
      queue.async {
        completion(error)
      }
    }
  }
}
