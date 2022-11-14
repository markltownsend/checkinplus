//
//  FoursquareAPI.swift
//  FoursquareAPI
//
//  Created by Mark Townsend on 12/12/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import Foundation

public protocol FoursquareAPI {
    nonisolated func authorizeUser(_ callbackURI: String) throws
    func generateAuthToken(with url: URL, callbackURI: String) async throws -> String?
    func getCheckInVenues(latitude: Double, longitude: Double) async throws -> [Venue]?
    func addCheckin(venueId: String, shout: String?) async throws
}
