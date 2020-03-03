//
//  FoursquareAPIManager.swift
//  FoursquareAPI
//
//  Created by Mark Townsend on 12/4/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import Foundation
import NetworkLayer
import FSOAuth
import Keys
import KeychainAccess

public enum AuthorizeUserError: Error {
  case foursquareOAuthNotSupported
  case invalideCallback
  case fouresquareNotInstalled
  case invalidClientID
}

public struct FoursquareAPIManager: FoursquareAPI {

  let router = Router<FoursquareApi>()

  public init() { }

  public func authorizeUser(_ callBackURI: String) throws {
    let status = FSOAuth.authorizeUser(usingClientId: CheckInPlusKeys().foursquareClientID,
                                       nativeURICallbackString: callBackURI,
                                       universalURICallbackString: "",
                                       allowShowingAppStore: true)
    switch status {
    case .success:
      print("Success!")
    case .errorFoursquareOAuthNotSupported:
      print("OauthNotSupported")
      throw AuthorizeUserError.foursquareOAuthNotSupported
    case .errorInvalidCallback:
      print("Invalid Call Back")
      throw AuthorizeUserError.invalideCallback
    case .errorFoursquareNotInstalled:
      print("FoursquareNotInstalled")
      throw AuthorizeUserError.fouresquareNotInstalled
    case .errorInvalidClientID:
      print("Invalid Cliend ID")
      throw AuthorizeUserError.invalidClientID
    default:
      print("None of those things happened")
    }
  }

  public func generateAuthToken(with url: URL, callbackURI: String, completion: @escaping (_ authToken: String?, _ error: Error?) -> ()) {
    var fsoauthError: FSOAuthErrorCode = .none
    if let accessCode = FSOAuth.accessCode(forFSOAuthURL: url, error: &fsoauthError) {
      FSOAuth.requestAccessToken(forCode: accessCode,
                                 clientId: CheckInPlusKeys().foursquareClientID,
                                 callbackURIString: callbackURI,
                                 clientSecret: CheckInPlusKeys().foursquareClientSecret) { (authToken, completed, errorCode) in

                                  if completed {
                                    if errorCode == .none {
                                      completion(authToken, nil)
                                    } else {
                                      completion(nil, nil)
                                    }
                                  }

      }
    }
  }

  public func getCheckInVenues(latitude: Double, longitude: Double, completion: @escaping (_ venues: [Venue]?, _ error: String?) -> Void) {

    router.request(.checkInSearch(latitude: latitude, longitude: longitude)) { (data, response, error) in
      guard error == nil else { completion(nil, "Check your network connection"); return }

      if let response = response as? HTTPURLResponse {
        let result = response.handleNetworkResponse()
        switch result {
        case .success:
          guard let responseData = data else {
            completion(nil, NetworkResponse.noData.rawValue)
            return
          }
          do {
            let apiResponse = try JSONDecoder().decode(CheckInVenuesResponse.self, from: responseData)
            completion(apiResponse.venues, nil)
          } catch {
            print("\(error)")
            completion(nil, NetworkResponse.unableToDecode.rawValue)
          }
        case .failure(let networkFailureError):
          completion(nil, networkFailureError)
        }
      }
    }
  }

  public func addCheckin(venueId: String, shout: String?, completion: @escaping (_: String?) -> Void) {
    router.request(.addCheckIn(venueId: venueId, shout: shout)) { (data, response, error) in
      guard error == nil else { completion(error?.localizedDescription); return }

      if let response = response as? HTTPURLResponse {
        let result = response.handleNetworkResponse()
        switch result {
        case .success:
          guard let _ = data else {
            completion(NetworkResponse.noData.rawValue)
            return
          }
          completion(nil)
        case .failure(let networkFailurError):
          completion(networkFailurError)
        }
      }
    }
  }
}

public extension Notification.Name {
  static let FoursquareDidSaveAuthTokenNotification =
    Notification.Name("FoursquareDidSaveAuthTokenNotification")
}

public extension FoursquareAPIManager {
  var keychainAuthTokenSuffix: String {
    "-FoursquareAuthToken"
  }

  var currentFoursquareAuthToken: String? {
    let keychain = Keychain(service: Keychain.serviceID)
    if let userIdentifier = Keychain.currentUserIdentifier {
      return keychain["\(userIdentifier)\(keychainAuthTokenSuffix)"]
    }
    return nil
  }

  func saveAuthToken(_ token: String) {
    let keychain = Keychain(service: Keychain.serviceID)
    if let userIdentifier = Keychain.currentUserIdentifier {
      keychain["\(userIdentifier)\(keychainAuthTokenSuffix)"] = token
      NotificationCenter.default.post(name: .FoursquareDidSaveAuthTokenNotification, object: nil, userInfo: nil)
    }
  }

  func retrieveAuthToken() -> String? {
    let keychain = Keychain(service: Keychain.serviceID)
    if let userIdIdentifier = Keychain.currentUserIdentifier {
      return keychain["\(userIdIdentifier)\(keychainAuthTokenSuffix)"]
    }
    return nil
  }

  func removeToken() {
    let keychain = Keychain(service: Keychain.serviceID)
    if let userIdentifier = Keychain.currentUserIdentifier {
      keychain["\(userIdentifier)\(keychainAuthTokenSuffix)"] = nil
    }
  }
}
