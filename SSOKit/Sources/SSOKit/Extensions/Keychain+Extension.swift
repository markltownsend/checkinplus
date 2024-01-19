//
//  KeyChain+Extension.swift
//
//
//  Created by Mark Townsend on 1/18/24.
//

import Foundation
import KeychainAccess
import os.log

public extension Keychain {
    static var userIdentifierKey: String {
        "userIdentifier"
    }

    static func currentUserIdentifier(serviceID: String? = nil) -> String {
        do {
            if let serviceID {
                return try Keychain(service: serviceID).get(userIdentifierKey) ?? ""
            } else {
                return try Keychain().get(userIdentifierKey) ?? ""
            }
        } catch {
            os_log("Error getting user identifier from keychain: \(error)")
            return ""
        }
    }
}
