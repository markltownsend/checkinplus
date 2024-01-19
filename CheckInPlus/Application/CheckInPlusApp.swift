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
import os.log
import SSOKit
import SwiftUI

extension FoursquareAPIManager: AuthenticationTokenGenerator {
    func generateAuthToken(with url: URL) {
        Task {
            guard let authToken = try? await generateAuthToken(with: url, callbackURI: Constants.callbackURI) else { return }
            saveAuthToken(authToken)
        }
    }
}

@main
struct CheckInPlusApp: App {
    @State private var showLogin = false
    @State private var appleSSOManager = AppleIdSSOManager()
    let foursquareManager = FoursquareAPIManager()

    var body: some Scene {
        WindowGroup {
            CheckInVenueListView()
                .onOpenURL { url in
                    foursquareManager.generateAuthToken(with: url)
                }
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
                    guard let webpageUrl = userActivity.webpageURL else { return }
                    foursquareManager.generateAuthToken(with: webpageUrl)
                }
                .task {
                    do {
                        showLogin = try await appleSSOManager.tryShowAppleSSOLogin()
                    } catch {
                        os_log("\(error.localizedDescription)")
                    }
                }
                .sheet(isPresented: $showLogin) {
                    LoginView(showModal: $showLogin)
                }
        }
        .environment(appleSSOManager)
    }
}
