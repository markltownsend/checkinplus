//
//  SettingsView.swift
//  CheckInPlus
//
//  Created by Mark Townsend on 12/10/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import FoursquareAPI
import KeychainAccess
import SwiftUI

@MainActor
struct SettingsView: View {
    private let foursquareManager = FoursquareAPIManager()
    private let keychain = Keychain(service: Keychain.serviceID)
    private let tokenSavedPublisher = NotificationCenter.default.publisher(for: .FoursquareDidSaveAuthTokenNotification)

    @Binding var showModal: Bool
    @State private var foursquareConnected = false

    var body: some View {
        NavigationView {
            VStack {
                Button(action: { self.connectToFoursquare() }) {
                    Text(self.foursquareConnected ? NSLocalizedString("Disconnect Foursquare", comment: "") : NSLocalizedString("Connect with Foursquare", comment: ""))
                }.padding()

                Button(action: {}) {
                    Text(NSLocalizedString("Connect with Yelp", comment: ""))
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("Settings", comment: "")))
            .navigationBarItems(trailing: Button(action: { self.showModal.toggle() }) {
                Text(NSLocalizedString("Done", comment: ""))
            }).onAppear {
                self.foursquareConnected = self.foursquareManager.currentAuthToken != nil
            }.onReceive(tokenSavedPublisher) { _ in
                self.foursquareConnected = true
            }
        }
    }

    func connectToFoursquare() {
        if foursquareConnected {
            foursquareManager.removeToken()
            foursquareConnected = false
        } else {
            do {
                try foursquareManager.authorizeUser(Constants.callbackURI)
            } catch {
                print("\(error)")
            }
        }
    }
}

#Preview("SettingsView") {
    SettingsView(showModal: .constant(true))
}
