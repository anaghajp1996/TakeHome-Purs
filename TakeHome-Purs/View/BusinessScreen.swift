//
//  BusinessScreen.swift
//  TakeHome-Purs
//
//  Created by Anagha K J on 20/05/24.
//

import SwiftUI

struct BusinessScreen: View {
    var businessVM = BusinessVM()
    @State var business: Business?
    @State var loading = false
    @State var collapseAccordion = true
    let imageURL = "https://lh3.googleusercontent.com/p/AF1QipNvaaR6eoBC7I48N_-ROU30qsi_h2Sf5eQRxWtr=s1360-w1360-h1020"

    var body: some View {
        VStack {
            if loading {
                FullScreenProgressIndicator()
            } else {
                if business == nil {
                    ErrorView(title: "Business details unavailable! Please try again later.")
                } else {
                    VStack {
                        HStack {
                            Text(business?.location ?? "")
                                .font(.custom(Constants.FiraSansBlack, size: 50))
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.leading)
                                .padding()
                            Spacer()
                        }
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.black.opacity(0.5), .clear]), startPoint: .top, endPoint: .bottom)
                        )
                        if let timings = business?.combinedHours {
                            Accordion(collapseAccordion: $collapseAccordion,
                                      timings: timings)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .padding()
                        }
                        Spacer()
                        ViewMenu()
                    }
                    .background(
                        AsyncImage(url: URL(string: imageURL)) { image in
                            image.image
                        }
                    )
                }
            }
        }
        .task {
            loading = true
            business = await businessVM.getBusinessDetails()
            loading = false
        }
    }
}

#Preview {
    BusinessScreen()
}

struct ViewMenu: View {
    var body: some View {
        VStack {
            Image(systemName: "chevron.up")
                .foregroundStyle(.white.opacity(0.5))
            Image(systemName: "chevron.up")
            Text("View Menu")
                .font(.custom(Constants.HindSiliguriReg, size: 24))
        }
        .foregroundStyle(.white)
    }
}
