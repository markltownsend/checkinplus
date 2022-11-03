//
//  CheckinView.swift
//  CheckInPlus
//
//  Created by Mark Townsend on 1/2/20.
//  Copyright © 2020 Mark Townsend. All rights reserved.
//

import SwiftUI

struct CheckinView: View {
    @Environment(\.presentationMode) var presentation
    @State private var shout: String = ""
    @State private var useFoursquare: Bool = true
    @State private var isShowingError = false
    @State private var isShowingSuccess = false
    @State private var currentErrorMessage: String = ""
    @State private var textHeight: CGFloat = 150
    private var venueId: String
    private var viewModel: CheckInVenueViewModel
    private var venueName: String

    init(venueId: String, venueName: String, viewModel: CheckInVenueViewModel) {
        self.viewModel = viewModel
        self.venueName = venueName
        self.venueId = venueId
    }

    var body: some View {
        VStack {
            Text("Add in what you're doing:")

            TextView(placeholder: "Enter here", text: $shout, minHeight: self.textHeight, calculatedHeight: self.$textHeight)
                .frame(minHeight: self.textHeight, maxHeight: self.textHeight)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 4.0)
                        .stroke(Color.primary, lineWidth: 1)
                )

            Button(action: { self.checkIn() }) {
                Text("Check In")
            }
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
        }.alert(isPresented: $isShowingSuccess) {
            Alert(title: Text("Checked In!"), message: Text("You're all checked in!"), dismissButton: .default(Text("OK")))
        }.navigationBarTitle(Text(venueName), displayMode: .inline)
    }

    func checkIn() {
        viewModel.checkIn(venueId: venueId, shout: shout) { error in
            guard let error else {
                DispatchQueue.main.async {
                    self.presentation.wrappedValue.dismiss()
                }
                return
            }
            self.currentErrorMessage = error
            self.isShowingError.toggle()
        }
    }
}

struct CheckinView_Previews: PreviewProvider {
    static var previews: some View {
        CheckinView(venueId: "", venueName: "", viewModel: CheckInVenueViewModel())
    }
}
