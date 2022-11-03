//
//  KeychainExtension.swift
//  FoursquareAPI
//
//  Created by Mark Townsend on 2/4/20.
//  Copyright © 2020 Mark Townsend. All rights reserved.
//

import Foundation
import KeychainAccess

// MARK: - Keychain extension that holds constants for the keychain

public extension Keychain {
    static var serviceID: String {
        "com.foursquare.service"
    }

    static var userIdentifierKey: String {
        "userIdentifier"
    }

    static var currentUserIdentifier: String? {
        do {
            return try Keychain(service: serviceID).get(userIdentifierKey)
        } catch {
            print("Error getting user identifier from keychain: \(error)")
            return nil
        }
    }
}
