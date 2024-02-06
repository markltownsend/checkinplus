//
//  FoursquareAPI.swift
//  FoursquareAPI
//
//  Created by Mark Townsend on 12/4/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import ArkanaKeys
import Foundation
import NetworkLayer

private let authentication = ["client_id": Keys.Global().foursquareClientID,
                              "client_secret": Keys.Global().foursquareClientSecret]
private let version = ["v": "20201231"]

public enum FoursquareError: Error {
    case badData
    case notFound
}

@MainActor
public enum FoursquareApi {
    case checkInSearch(latitude: Double, longitude: Double)
    case addCheckIn(venueId: String, shout: String?)
}

@MainActor
extension FoursquareApi: EndPointType {
    private func urlParametersWithAuthentication(parameters: Parameters) -> Parameters {
        parameters.merging(authentication) { current, _ in current }.merging(version) { current, _ in current }
    }

    private func urlParametersWithAuthToken(parameters: Parameters) -> Parameters {
        let oauthToken = ["oauth_token": FoursquareAPIManager().currentAuthToken ?? ""]
        return parameters.merging(oauthToken) { current, _ in current }.merging(version) { current, _ in current }
    }

    public var baseURL: URL {
        guard let url = URL(string: "https://api.foursquare.com/v2/") else { fatalError("baseURL could not be configured.") }
        return url
    }

    public var path: String {
        switch self {
        case .checkInSearch:
            return "venues/search"
        case .addCheckIn:
            return "checkins/add"
        }
    }

    public var httpMethod: HTTPMethod {
        switch self {
        case .checkInSearch:
            return .get
        case .addCheckIn:
            return .post
        }
    }

    public var task: HTTPTask {
        switch self {
        case let .checkInSearch(latitude, longitude):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: urlParametersWithAuthentication(parameters:
                ["ll": "\(latitude),\(longitude)",
                 "intent": "checkin",
                 "radius": "50"]))
        case let .addCheckIn(venueId, shout):
            var parameters = [String: Any]()
            parameters["venueId"] = venueId
            if let shout {
                parameters["shout"] = shout
            }
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: urlParametersWithAuthToken(parameters: parameters))
        }
    }

    public var headers: HTTPHeaders? {
        nil
    }
}
