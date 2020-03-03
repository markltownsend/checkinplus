//
//  ContentView.swift
//  CheckInPlus
//
//  Created by Mark Townsend on 10/19/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import SwiftUI
import URLImage

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
        NavigationLink(destination: CheckinView(venueId: venue.id, venueName: venue.name, viewModel: self.viewModel)) {
          HStack {
            URLImage(url: venue.getPrimaryCategoryIconURL(), placeholder: Image(systemName: "app"), contentMode: .fit)
              .frame(width: 32, height: 32, alignment: .center)
            Text(venue.name)
          }.padding()
        }
      }.navigationBarTitle(Text("Venues"))
        .navigationBarItems(trailing: settingsButton)
        .sheet(isPresented: $settingsShowing) {
          SettingsView(showModal: self.$settingsShowing)
      }
    }.onAppear() {
      self.viewModel.loadData()
    }.alert(isPresented: self.$viewModel.hasError) {
      Alert(title: Text("Error"), message: Text(self.viewModel.venueError), dismissButton: .default(Text("OK")))
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
