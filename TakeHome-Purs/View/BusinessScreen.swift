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
    @State var collapseAccordion = false
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
                        if let hours = business?.hours {
                            Accordion(title:
                                AnyView(
                                    HStack {
                                        Text("title here")
                                            .font(.custom(Constants.HindSiliguriReg, size: 18))
                                        Circle()
                                            .fill(.green)
                                            .frame(width: 7, height: 7)
                                    }), collapseAccordion: $collapseAccordion, hours: hours)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .padding()
                        }
                        Spacer()
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
