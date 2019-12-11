//
//  ContentView.swift
//  CheckInPlus
//
//  Created by Mark Townsend on 10/19/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import SwiftUI

struct CheckInVenueListView: View {
    @ObservedObject private var viewModel: CheckInVenueViewModel
    @State private var settingsShowing = false

    init() {
        self.viewModel = CheckInVenueViewModel()
    }

    var settingsButton: some View {
        Button(action: { self.settingsShowing = true}) {
            Image(systemName: "gear")
                .padding(EdgeInsets(top: 40, leading: 40, bottom: 40, trailing: 10))
        }
    }

    var body: some View {
        NavigationView {
            List(viewModel.venues) { venue in
                Text(venue.name)
            }.navigationBarTitle(Text("Venues"))
            .navigationBarItems(trailing: settingsButton)
            .sheet(isPresented: $settingsShowing) {
                SettingsView(showModal: self.$settingsShowing)
            }
        }.onAppear() {
            self.viewModel.loadData()
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInVenueListView()
    }
}
#endif
