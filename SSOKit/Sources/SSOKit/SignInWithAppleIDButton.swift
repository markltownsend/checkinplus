//
//  SignInWithAppleIDButton.swift
//
//
//  Created by Mark Townsend on 1/16/24.
//

import AuthenticationServices.ASAuthorizationAppleIDButton
import SwiftUI

struct SignInWithAppleIDButton: UIViewRepresentable {
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton()
    }

    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
}
