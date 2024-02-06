//
//  AuthenticationTokenGenerator.swift
//  CheckInPlus
//
//  Created by Mark Townsend on 1/11/24.
//  Copyright © 2024 Mark Townsend. All rights reserved.
//

import Foundation

/// Manages the CRUD actions of creating an auth token for a service
public protocol AuthenticationTokenGenerator {
    /// Used as the suffix of the key used to store the auth token
    var keychainAuthTokenSuffix: String { get }
    var currentAuthToken: String? { get }
    @discardableResult
    func generateAuthToken(with url: URL, callbackURI: String?) async throws -> String?
    func saveAuthToken(_ token: String)
    func removeToken()
}
