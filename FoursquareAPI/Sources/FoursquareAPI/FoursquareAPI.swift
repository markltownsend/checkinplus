//
//  FoursquareAPI.swift
//  FoursquareAPI
//
//  Created by Mark Townsend on 12/12/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import Foundation

public protocol FoursquareAPI {
    func authorizeUser(_ callbackURI: String) throws
    func generateAuthToken(with url: URL, callbackURI: String, completion: @escaping (_ authToken: String?, _ error: Error?) -> Void)
    func getCheckInVenues(latitude: Double, longitude: Double, completion: @escaping (_ venues: [Venue]?, _ error: String?) -> Void)
    func addCheckin(venueId: String, shout: String?, completion: @escaping (_ error: String?) -> Void)
}

