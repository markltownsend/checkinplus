//
//  SettingsView.swift
//  CheckInPlus
//
//  Created by Mark Townsend on 12/10/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @Binding var showModal: Bool

    var body: some View {
        NavigationView {
            VStack {
                Button(action:{}) {
                    Text(NSLocalizedString("Connect with Foursquare", comment: ""))
                }.padding()

                Button(action:{}) {
                    Text(NSLocalizedString("Connect with Yelp", comment: ""))
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("Settings", comment: "")))
            .navigationBarItems(trailing: Button(action: { self.showModal.toggle()}) {
                Text(NSLocalizedString("Done", comment: ""))
            })

        }

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showModal: .constant(true))
    }
}
