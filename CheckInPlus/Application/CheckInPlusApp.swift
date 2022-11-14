//
//  CheckInPlusApp.swift
//  CheckInPlus
//
//  Created by Mark Townsend on 11/8/22.
//  Copyright © 2022 Mark Townsend. All rights reserved.
//

import AuthenticationServices
import FoursquareAPI
import KeychainAccess
import SwiftUI

@main
struct CheckInPlusApp: App {
    @State private var showLogin = false
    let foursquareManager: FoursquareAPIManager

    init() {
        foursquareManager = FoursquareAPIManager()
    }

    var body: some Scene {
        WindowGroup {
            CheckInVenueListView()
                .onOpenURL { url in
                    generateAuthToken(with: url)
                }
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
                    guard let webpageUrl = userActivity.webpageURL else { return }
                    generateAuthToken(with: webpageUrl)
                }
                .onAppear {
                    tryShowAppleSSOLogin()
                }
                .sheet(isPresented: $showLogin) {
                    LoginView(showModal: $showLogin)
                }
        }
    }

    private func generateAuthToken(with url: URL) {
        Task {
            guard let authToken = try? await foursquareManager.generateAuthToken(with: url, callbackURI: Constants.callbackURI) else { return }
            await foursquareManager.saveAuthToken(authToken)
        }
    }

    private func tryShowAppleSSOLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: Keychain.currentUserIdentifier ?? "") { credentialState, _ in
            switch credentialState {
            case .authorized:
                // Apple ID valid
                break
            case .revoked:
                fallthrough
            case .notFound:
                showLogin = true
            default:
                break

            }
        }
    }
    
}
