//
//  AuthenticationTokenGenerator.swift
//  CheckInPlus
//
//  Created by Mark Townsend on 1/11/24.
//  Copyright © 2024 Mark Townsend. All rights reserved.
//

import Foundation

protocol AuthenticationTokenGenerator {
    func generateAuthToken(with url: URL)
}
