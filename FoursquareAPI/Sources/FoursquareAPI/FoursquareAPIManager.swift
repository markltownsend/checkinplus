//
//  FoursquareAPIManager.swift
//  FoursquareAPI
//
//  Created by Mark Townsend on 12/4/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import ArkanaKeys
import Foundation
import FSOAuth
import KeychainAccess
import NetworkLayer
import os.log
import SSOKit

public enum AuthorizeUserError: Error {
    case foursquareOAuthNotSupported
    case invalidCallback
    case fourSquareNotInstalled
    case invalidClientID
}

@MainActor
public struct FoursquareAPIManager: FoursquareAPI {
    public static var serviceID: String {
        "com.foursquare.service"
    }
    
    let router = Router<FoursquareApi>()

    nonisolated public init() {}

    nonisolated public func authorizeUser(_ callBackURI: String) throws {
        let status = FSOAuth.authorizeUser(
            usingClientId: Keys.Global().foursquareClientID,
            nativeURICallbackString: callBackURI,
            universalURICallbackString: "",
            allowShowingAppStore: true
        )
        switch status {
        case .success:
            os_log(.debug, "Success!")
        case .errorFoursquareOAuthNotSupported:
            os_log(.debug, "OauthNotSupported")
            throw AuthorizeUserError.foursquareOAuthNotSupported
        case .errorInvalidCallback:
            os_log(.debug, "Invalid Call Back")
            throw AuthorizeUserError.invalidCallback
        case .errorFoursquareNotInstalled:
            os_log(.debug, "FoursquareNotInstalled")
            throw AuthorizeUserError.fourSquareNotInstalled
        case .errorInvalidClientID:
            os_log(.debug, "Invalid Client ID")
            throw AuthorizeUserError.invalidClientID
        default:
            os_log(.debug, "None of those things happened")
        }
    }

    public func getCheckInVenues(latitude: Double, longitude: Double) async throws -> [Venue]? {
        let (data, response) = try await router.request(.checkInSearch(latitude: latitude, longitude: longitude))
        guard let response = response as? HTTPURLResponse else { return nil }
        let result = response.handleNetworkResponse()
        switch result {
        case .success:
            do {
                let apiResponse = try JSONDecoder().decode(CheckInVenuesResponse.self, from: data)
                return apiResponse.venues
            } catch {
                throw NetworkResponseError.unableToDecode
            }
        case let .failure(networkFailureError):
            throw networkFailureError
        }
    }

    public func addCheckin(venueId: String, shout: String?) async throws {
        let (_, response) = try await router.request(.addCheckIn(venueId: venueId, shout: shout))
        guard let response = response as? HTTPURLResponse else { return }
        let result = response.handleNetworkResponse()
        switch result {
        case .success:
            return
        case let .failure(networkFailureError):
            throw networkFailureError
        }
    }
}

public extension Notification.Name {
    static let FoursquareDidSaveAuthTokenNotification =
        Notification.Name("FoursquareDidSaveAuthTokenNotification")
}

extension FoursquareAPIManager: AuthenticationTokenGenerator {
    public var keychainAuthTokenSuffix: String {
        "-FoursquareAuthToken"
    }

    public var currentAuthToken: String? {
        let keychain = Keychain()

        let userIdentifier = Keychain.currentUserIdentifier()

        return keychain["\(userIdentifier)\(keychainAuthTokenSuffix)"]
    }
    
    public func generateAuthToken(with url: URL, callbackURI: String?) async throws -> String? {
        var fsOAuthError: FSOAuthErrorCode = .none
        guard let accessCode = FSOAuth.accessCode(forFSOAuthURL: url, error: &fsOAuthError),
              let callbackURI
        else { return nil }

        return await withCheckedContinuation { continuation in
            FSOAuth.requestAccessToken(
                forCode: accessCode,
                clientId: Keys.Global().foursquareClientID,
                callbackURIString: callbackURI,
                clientSecret: Keys.Global().foursquareClientSecret
            ) { authToken, completed, errorCode in
                guard completed, errorCode == .none, let authToken
                else {
                    continuation.resume(returning: nil)
                    return
                }

                saveAuthToken(authToken)
                continuation.resume(returning: authToken)
            }
        }
    }

    public func saveAuthToken(_ token: String) {
        let keychain = Keychain()
        let userIdentifier = Keychain.currentUserIdentifier()
        keychain["\(userIdentifier)\(keychainAuthTokenSuffix)"] = token
        NotificationCenter.default.post(name: .FoursquareDidSaveAuthTokenNotification, object: nil, userInfo: nil)
    }

    public func removeToken() {
        let keychain = Keychain()
        let userIdentifier = Keychain.currentUserIdentifier()
        keychain["\(userIdentifier)\(keychainAuthTokenSuffix)"] = nil
    }
}
