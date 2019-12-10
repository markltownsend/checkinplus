//
//  FoursquareVenue.swift
//  FoursquareAPI
//
//  Created by Mark Townsend on 12/4/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import Foundation

public struct CheckInVenuesResponse {
    let venues: [Venue]
}

extension CheckInVenuesResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case response
        case venues
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let response = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        venues = try response.decode([Venue].self, forKey: .venues)
    }
}

public struct Venue: Decodable, Identifiable {
    public let id: String
    public let name: String
    public let location: Location?
}

public struct Location: Decodable {
    public let distance: Int
    public let formattedAddress: [String]

    public func addressDisplay() -> String {
        return formattedAddress.joined(separator: "\n")
    }
}

