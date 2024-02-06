//
//  AppleIdSSOManager.swift
//
//
//  Created by Mark Townsend on 1/16/24.
//

import AuthenticationServices
import Foundation
import KeychainAccess
import Observation
import os.log
import SwiftUI

@Observable
public final class AppleIdSSOManager: SSOManager {
    private let userIdentifierKey = "userIdentifier"
//    private let keychains: [Keychain]
    private let keychain = Keychain()

    public init() {}
//    public init(serviceIDs: [String]) {
//        var chains = [Keychain]()
//        for serviceID in serviceIDs {
//            chains.append(Keychain(service: serviceID))
//        }
//        keychains = chains
//    }

//    public func showAppleSSOLogin() async -> Bool {
//        let request = ASAuthorizationAppleIDProvider().createRequest()
//        request.requestedScopes = [.fullName, .email]
//
//        return await performSignIn(using: [request])
//    }

//    public func performExistingAccountSetupFlow() async -> Bool{
//        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
//                        ASAuthorizationPasswordProvider().createRequest()]
//        return await performSignIn(using: requests)
//    }

    func saveCredential(_ userIdentifier: String) {
        keychain[userIdentifierKey] = userIdentifier
    }

//    func performSignIn(using requests: [ASAuthorizationRequest]) async -> Bool {
//            do {
//                let result = try await authorizationController.performRequests(requests)
//                processSignIn(result)
//                return false
//            } catch {
//                os_log(
//                    "Error logging in: %s",
//                    log: OSLog.default,
//                    type: .error,
//                    error.localizedDescription
//                )
//                return true
//            }
//    }

    public func tryShowSSOLogin() async throws -> Bool {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        do {
            let credentialState = try await appleIDProvider.credentialState(forUserID: Keychain.currentUserIdentifier())
            switch credentialState {
            case .authorized:
                // Apple ID valid
                return false
            case .revoked:
                fallthrough
            case .notFound:
                return true
            default:
                break
            }
        } catch {
            return true
        }
        return true
    }
}
