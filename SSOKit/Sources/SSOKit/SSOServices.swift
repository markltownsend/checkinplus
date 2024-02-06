//
//  File.swift
//  
//
//  Created by Mark Townsend on 1/18/24.
//

import Foundation

public protocol SSOManager {
    func tryShowSSOLogin() async throws -> Bool
}

public enum SSOServices: CaseIterable {
    case apple
    case google
    case facebook

    public var ssoManager: SSOManager? {
        switch self {
        case .apple: AppleIdSSOManager()
        case .facebook: nil
        case .google: nil
        }
    }
}
