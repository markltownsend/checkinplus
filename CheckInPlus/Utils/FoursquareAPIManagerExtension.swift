//
//  FoursquareAPIManagerExtension.swift
//  CheckInPlus
//
//  Created by Mark Townsend on 12/15/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import Foundation
import FoursquareAPI
import KeychainAccess

extension Notification.Name {
    static let FoursquareDidSaveAuthTokenNotification =
        Notification.Name("FoursquareDidSaveAuthTokenNotification")
}

extension FoursquareAPIManager {
    var keychainAuthTokenSuffix: String {
        "-FoursquareAuthToken"
    }

    var currentFoursquareAuthToken: String? {
        let keychain = Keychain(service: Keychain.serviceID)
        if let appleIdIdentifier = Keychain.currentUserIdentifier {
            return keychain["\(appleIdIdentifier)\(keychainAuthTokenSuffix)"]
        }
        return nil
    }
    
    func saveAuthToken(_ token: String) {
        let keychain = Keychain(service: Keychain.serviceID)
        if let appleIdIdentifier = Keychain.currentUserIdentifier {
            keychain["\(appleIdIdentifier)\(keychainAuthTokenSuffix)"] = token
            NotificationCenter.default.post(name: .FoursquareDidSaveAuthTokenNotification, object: nil, userInfo: nil)
        }
    }

    func retrieveAuthToken() -> String? {
        let keychain = Keychain(service: Keychain.serviceID)
        if let appleIdIdentifier = Keychain.currentUserIdentifier {
            return keychain["\(appleIdIdentifier)\(keychainAuthTokenSuffix)"]
        }
        return nil
    }

    func removeToken() {
        let keychain = Keychain(service: Keychain.serviceID)
        if let appleIdIdentifier = Keychain.currentUserIdentifier {
            keychain["\(appleIdIdentifier)\(keychainAuthTokenSuffix)"] = nil
        }
    }

}
