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

@main
struct CheckInPlusApp: App {
    @State private var showErrorAlert = false
    @State private var showLogin = false
    let authTokenGenerator: AuthenticationTokenGenerator = FoursquareAPIManager()

    var body: some Scene {
        WindowGroup {
            CheckInVenueListView()
                .onOpenURL { url in
                    Task {
                        do {
                            try await authTokenGenerator.generateAuthToken(with: url, callbackURI: Constants.callbackURI)
                        } catch {
                            showErrorAlert = true
                        }
                    }
                }
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
                    guard let webpageUrl = userActivity.webpageURL else { return }
                    Task {
                        do {
                            try await authTokenGenerator.generateAuthToken(with: webpageUrl, callbackURI: Constants.callbackURI)
                        } catch {
                            showErrorAlert = true
                        }
                    }
                }
                .task {
                    do {
                        for ssoService in SSOServices.allCases {
                            guard !showLogin, let ssoManager = ssoService.ssoManager else { return }
                            #if !targetEnvironment(simulator)
                            showLogin = try await ssoManager.tryShowSSOLogin()
                            #endif
                        }
                    } catch {
                        os_log("\(error.localizedDescription)")
                    }
                }
                .sheet(isPresented: $showLogin) {
                    LoginView(showModal: $showLogin)
                }
        }
    }
}
