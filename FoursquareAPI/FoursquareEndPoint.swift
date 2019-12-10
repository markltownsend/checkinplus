//
//  FoursquareAPI.swift
//  FoursquareAPI
//
//  Created by Mark Townsend on 12/4/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import Foundation
import NetworkLayer
import Keys

private let authentication = ["client_id": CheckInPlusKeys().foursquareClientID,
                              "client_secret": CheckInPlusKeys().foursquareClientSecret]
private let version = ["v": "20201231"]

public enum FoursquareError: Error {
    case badData
    case notFound
}

public enum FoursquareApi {
    case checkInSearch(latitude:Double, longitude:Double)
}

extension FoursquareApi: EndPointType {

    private func urlParametersWithAuthentication(parameters: Parameters) -> Parameters {
        return parameters.merging(authentication) { (current, _) in current }.merging(version) { (current, _) in current }
    }

    public var baseURL: URL {
        guard let url = URL(string: "https://api.foursquare.com/v2/") else { fatalError("baseURL could not be configured.")}
        return url
    }

    public var path: String {
        switch self {
        case .checkInSearch:
            return "venues/search"
        }
    }

    public var httpMethod: HTTPMethod {
        return .get
    }

    public var task: HTTPTask {
        switch self {
        case .checkInSearch(let latitude, let longitude):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: urlParametersWithAuthentication(parameters:
                ["ll": "\(latitude),\(longitude)",
                 "intent":"checkin",
                 "radius":"50"]))
        }
    }

    public var headers: HTTPHeaders? {
        return nil
    }

    
}
