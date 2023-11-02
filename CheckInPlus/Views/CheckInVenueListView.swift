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
    @State private var searchText: String = ""

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
            List(viewModel.searchResults(searchText: searchText)) { venue in
                NavigationLink(destination: CheckinView(venueId: venue.id, venueName: venue.name)) {
                    HStack {
                        AsyncImage(url: venue.getPrimaryCategoryIconURL())
                            .frame(width: 32, height: 32, alignment: .center)
                            .padding(6.0)
                            .background(Color.green)
                            .cornerRadius(19.0)
                        Text(venue.name)
                    }
                    .padding()
                }
            }
            .listStyle(.inset)
            .navigationBarTitle(Text("Venues"))
            .navigationBarItems(trailing: settingsButton)
            .searchable(text: $searchText, placement: .automatic)
            .sheet(isPresented: $settingsShowing) {
                SettingsView(showModal: $settingsShowing)
            }
        }
        .alert(isPresented: $viewModel.hasError) {
            Alert(title: Text("Error"), message: Text(viewModel.venueError!.rawValue), dismissButton: .default(Text("OK")))
        }
        .environmentObject(viewModel)
    }
}

#Preview("CheckInVenueListView") {
    CheckInVenueListView()
}
