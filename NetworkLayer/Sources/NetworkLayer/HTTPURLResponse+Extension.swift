//
//  HTTPURLResponse+Extension.swift
//  NetworkLayer
//
//  Created by Mark Townsend on 12/4/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import Foundation

public enum NetworkResponseError: String, Error {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

public enum NetworkResponseResult<String> {
    case success
    case failure(NetworkResponseError)
}

public extension HTTPURLResponse {
    func handleNetworkResponse() -> NetworkResponseResult<String> {
        switch statusCode {
        case 200 ... 299: return .success
        case 400 ... 499: return .failure(NetworkResponseError.authenticationError)
        case 500 ... 599: return .failure(NetworkResponseError.badRequest)
        case 600: return .failure(NetworkResponseError.outdated)
        default: return .failure(NetworkResponseError.failed)
        }
    }
}
