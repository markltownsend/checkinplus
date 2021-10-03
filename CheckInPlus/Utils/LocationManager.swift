//
//  LocationManager.swift
//  CheckInPlus
//
//  Created by Mark Townsend on 12/9/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import Combine
import CoreLocation
import Foundation
import os
import UIKit

final class LocationManager: NSObject {
  private var firstTimeUpdatingLocation = true
  private let locManager = CLLocationManager()
  private var cancellables = Set<AnyCancellable>()

  @Published public var currentLocation: (latitude: Double, longitude: Double)?

  override init() {
    super.init()
    locManager.delegate = self
    locManager.requestWhenInUseAuthorization()
    setupNotifications()
  }

  func startScanning() {
    os_log("Start Scanning")
    locManager.startUpdatingLocation()
  }

  func stopScanning() {
    os_log("Stop Scanning")
    locManager.stopUpdatingLocation()
  }

  func setupNotifications() {
    let center = NotificationCenter.default
    center.publisher(for: UIApplication.willEnterForegroundNotification, object: nil)
      .sink { [weak self] _ in
        self?.startScanning()
      }
      .store(in: &cancellables)
    center.publisher(for: UIApplication.didEnterBackgroundNotification, object: nil)
      .sink { [weak self] _ in
        self?.stopScanning()
      }
      .store(in: &cancellables)
  }

}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedWhenInUse, .authorizedAlways:
      startScanning()
      break
    case .denied:
      // Show denied error
      print("Location Service denied")
      break
    case .notDetermined:
      print("Location Service permission could not be determined")
      break
    case .restricted:
      print("Location Service permission has been restricted")
      break
    @unknown default:
      fatalError()
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("\(#function): \(error)")
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }

    os_log("Updating locations")

    currentLocation = (location.coordinate.latitude, location.coordinate.longitude)
  }
}
