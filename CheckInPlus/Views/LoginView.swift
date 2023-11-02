//
//  LoginView.swift
//  CheckInPlus
//
//  Created by Mark Townsend on 11/8/22.
//  Copyright © 2022 Mark Townsend. All rights reserved.
//

import SwiftUI
import AuthenticationServices

private struct SignInWithAppleView: UIViewRepresentable {
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton()
    }

    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {

    }
}

struct LoginView: View {
    @State private var appleSignInDelegate: AppleSignInDelegate! = nil
    @Binding var showModal: Bool

    var body: some View {
        VStack {
            Text("CheckIn Plus")
                .font(.system(.largeTitle))
            
            SignInWithAppleView()
                .frame(width: 280, height: 60)
                .onTapGesture {
                    showAppleSSOLogin()
                }
                .onAppear {
                    performExistingAccountSetupFlow()
                }
        }
    }

    private func showAppleSSOLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        performSignIn(using: [request])
    }

    private func performExistingAccountSetupFlow() {
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        performSignIn(using: requests)
    }

    private func performSignIn(using requests: [ASAuthorizationRequest]) {
        appleSignInDelegate = AppleSignInDelegate { success in
            if success {
                self.showModal = false
            } else {

            }
        }

        let controller = ASAuthorizationController(authorizationRequests: requests)
        controller.delegate = appleSignInDelegate
        controller.performRequests()

    }
}

#Preview("Login View") {
    LoginView(showModal: .constant(true))
}
