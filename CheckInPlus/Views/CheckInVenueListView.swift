//
//  ContentView.swift
//  CheckInPlus
//
//  Created by Mark Townsend on 10/19/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import SwiftUI

struct CheckInVenueListView: View {
    @ObservedObject var viewModel: CheckInVenueViewModel

    init() {
        self.viewModel = CheckInVenueViewModel()
    }

    var body: some View {
        NavigationView {
            List(viewModel.venues) { venue in
                Text(venue.name)
            }.navigationBarTitle(Text("Venues"))
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
