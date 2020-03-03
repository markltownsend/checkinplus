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
  
  @Published private(set) var venues: [Venue] = []
  @Published private(set) var venueError: String = ""
  @Published var hasError = false
  @Published var checkInSuccess = false
  
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
