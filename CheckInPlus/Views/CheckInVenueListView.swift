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
        let viewModel = CheckInVenueViewModel()
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }

    var settingsButton: some View {
        Button(action: { settingsShowing = true }) {
            Image(systemName: "gear")
                .padding(EdgeInsets(top: 40, leading: 40, bottom: 40, trailing: 10))
        }
    }

    var body: some View {
        NavigationView {
            List(viewModel.venues) { venue in
                NavigationLink(destination: CheckinView(venueId: venue.id, venueName: venue.name, viewModel: viewModel)) {
                    HStack {
                        AsyncImage(url: venue.getPrimaryCategoryIconURL())
                            .frame(width: 32, height: 32, alignment: .center)
                            .padding(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
                            .background(Color.green)
                            .cornerRadius(19.0)
                        Text(venue.name)
                    }
                    .padding()
                }
            }
            .navigationBarTitle(Text("Venues"))
            .navigationBarItems(trailing: settingsButton)
            .sheet(isPresented: $settingsShowing) {
                SettingsView(showModal: $settingsShowing)
            }
        }
        .alert(isPresented: $viewModel.hasError) {
            Alert(title: Text("Error"), message: Text(viewModel.venueError!.rawValue), dismissButton: .default(Text("OK")))
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
