//
//  AppleSignInDelegate.swift
//  CheckInPlus
//
//  Created by Mark Townsend on 11/8/22.
//  Copyright © 2022 Mark Townsend. All rights reserved.
//

import AuthenticationServices
import Foundation
import KeychainAccess
import os.log

final class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate {
    private let keychain = Keychain(service: Keychain.serviceID)
    private var completionBlock: (Bool) -> Void

    init(_ completion: @escaping (Bool) -> Void) {
        completionBlock = completion
        super.init()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            keychain[Keychain.userIdentifierKey] = userIdentifier
            completionBlock(true)
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            os_log("Got credential from keychain for %{private}@", passwordCredential.user)
            completionBlock(false)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        os_log("Error logging in: %s", log: OSLog.default, type: .error, error.localizedDescription)
    }
}
