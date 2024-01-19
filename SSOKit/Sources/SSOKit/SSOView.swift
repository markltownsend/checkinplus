//
//  SwiftUIView.swift
//  
//
//  Created by Mark Townsend on 1/16/24.
//

import AuthenticationServices
import KeychainAccess
import os.log
import SwiftUI

public struct SSOView: View {
    @Environment(\.authorizationController) private var authorizationController
    @Binding var showModal: Bool
    @State private var appleSSOManager = AppleIdSSOManager()
    private let services: [SSOServices]

    public init(services: [SSOServices], showModal: Binding<Bool>) {
        self.services = services
        self._showModal = showModal
    }

    public var body: some View {
        VStack {
            ForEach(services, id: \.self) { service in
                switch service {
                case .apple:
                    SignInWithAppleButton(.signIn, onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                    }, onCompletion: { result in
                        switch result {
                        case .success(let success):
                            if let appleID = success.credential as? ASAuthorizationAppleIDCredential {
                                appleSSOManager.saveCredential(appleID.user)
                            }
                        case .failure(let failure):
                            os_log("Failure logging in: \(failure.localizedDescription)")
                        }
                        showModal = false
                    })
                    .frame(width: 280, height: 60)
                case .facebook:
                    Button(
                        action: {},
                        label: {
                            Text("Sign in with Facebook")
                        })

                case .google:
                    Button(
                        action: {},
                        label: {
                            Text("Sign in with Google")
                        })
                }
            }
        }
        .buttonStyle(.borderedProminent)
//        .task {
//            showModal = await appleSSOManager.performExistingAccountSetupFlow()
//        }
    }
}

#Preview {
    SSOView(services: [.apple, .google, .facebook], showModal: .constant(true))

}
