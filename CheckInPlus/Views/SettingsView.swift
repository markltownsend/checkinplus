//
//  SettingsView.swift
//  CheckInPlus
//
//  Created by Mark Townsend on 12/10/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import SwiftUI
import FoursquareAPI
import KeychainAccess

struct SettingsView: View {
    private let fqManager = FoursquareAPIManager()
    private let keychain = Keychain(service: Keychain.serviceID)
    private let tokenSavedPublisher = NotificationCenter.default.publisher(for: .FoursquareDidSaveAuthTokenNotification)

    @Binding var showModal: Bool
    @State private var foursquareConnected = false

    var body: some View {
        NavigationView {
            VStack {
                Button(action:{ self.connectToFoursquare() }) {
                    Text(self.foursquareConnected ? NSLocalizedString("Disconnect Foursquare", comment: "") : NSLocalizedString("Connect with Foursquare", comment: ""))
                }.padding()

                Button(action:{}) {
                    Text(NSLocalizedString("Connect with Yelp", comment: ""))
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("Settings", comment: "")))
            .navigationBarItems(trailing: Button(action: { self.showModal.toggle()}) {
                Text(NSLocalizedString("Done", comment: ""))
            }).onAppear {
                self.foursquareConnected = self.fqManager.currentFoursquareAuthToken != nil
            }.onReceive(tokenSavedPublisher) { (_) in
                self.foursquareConnected = true
            }
        }
    }

    func connectToFoursquare() {
        if foursquareConnected {
            fqManager.removeToken()
            foursquareConnected = false
        } else {
            do {
                try fqManager.authorizeUser(Constants.callbackURI)
            } catch {
                print("\(error)")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showModal: .constant(true))
    }
}
