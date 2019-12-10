//
//  FoursquareAPIManager.swift
//  FoursquareAPI
//
//  Created by Mark Townsend on 12/4/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import Foundation
import NetworkLayer

public struct FoursquareAPIManager {
    let router = Router<FoursquareApi>()

    public init() { }
    
    public func getCheckInVenues(latitude:Double, longitude:Double, completion: @escaping (_ venues: [Venue]?, _ error: String?)->()) {
        router.request(.checkInSearch(latitude: latitude, longitude: longitude)) { (data, response, error) in

            if error != nil {
                completion(nil, "Check your network connection")
            }

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
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
}
