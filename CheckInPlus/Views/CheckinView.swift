//
//  CheckinView.swift
//  CheckInPlus
//
//  Created by Mark Townsend on 1/2/20.
//  Copyright © 2020 Mark Townsend. All rights reserved.
//

import NetworkLayer
import SwiftUI

struct CheckinView: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject private var viewModel: CheckInVenueViewModel

    @State private var shout: String = ""
    @State private var useFoursquare: Bool = true
    @State private var isShowingError = false
    @State private var isShowingSuccess = false
    @State private var isShowingSettings = false
    @State private var currentErrorMessage: String = ""
    @State private var textHeight: CGFloat = 150
    private var venueId: String
    private var venueName: String

    init(venueId: String, venueName: String) {
        self.venueName = venueName
        self.venueId = venueId
    }

    var body: some View {
        ScrollView {
            VStack {
                Text("Add in what you're doing:")
                    .font(.headline)

                TextEditor(text: $shout)
                    .font(.body)
                    .frame(minHeight: self.textHeight, maxHeight: self.textHeight)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 4.0)
                            .stroke(Color.primary, lineWidth: 1)
                    )

                Button(action: checkIn) {
                    Text("Check In")
                        .font(.caption)
                        .padding(3)
                }
                .buttonBorderShape(.capsule)
                .buttonStyle(.borderedProminent)
                .padding()

                HStack {
                    Toggle(isOn: $useFoursquare) {
                        Text("Foursquare")
                    }
                    .padding()
                }
                Spacer()
            }
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
            .alert(isPresented: $isShowingError) {
                Alert(title: Text("Try again."), message: Text(self.currentErrorMessage), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $isShowingSuccess) {
                Alert(title: Text("Checked In!"), message: Text("You're all checked in!"), dismissButton: .default(Text("OK")))
            }
            .navigationBarTitle(Text(venueName), displayMode: .inline)
            .sheet(isPresented: $isShowingSettings) {
                SettingsView(showModal: $isShowingSettings)
            }
        }
    }

    func checkIn() {
        guard viewModel.isCurrentlyLoggedIn
        else {
            isShowingSettings.toggle()
            return
        }
        do {
            try viewModel.checkIn(venueId: venueId, shout: shout)
            presentation.wrappedValue.dismiss()
        } catch let error as NetworkResponseError {
            currentErrorMessage = error.rawValue
            isShowingError.toggle()
        } catch {
            isShowingError.toggle()
        }
    }
}

#Preview("CheckInView") {
    NavigationView {
        CheckinView(venueId: "", venueName: "Awesome Place To Be")
            .environmentObject(CheckInVenueViewModel())
    }
}
