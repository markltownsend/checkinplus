//
//  LoginView.swift
//  CheckInPlus
//
//  Created by Mark Townsend on 11/8/22.
//  Copyright © 2022 Mark Townsend. All rights reserved.
//

import AuthenticationServices
import KeychainAccess
import os.log
import SSOKit
import SwiftUI


struct LoginView: View {
    @Binding var showModal: Bool
    var body: some View {
        VStack {
            Text("CheckIn Plus")
                .font(.system(.largeTitle))
            
            SSOView(services: [.apple], showModal: $showModal)
        }
    }
}

#Preview("Login View") {
    LoginView(showModal: .constant(true))
}
