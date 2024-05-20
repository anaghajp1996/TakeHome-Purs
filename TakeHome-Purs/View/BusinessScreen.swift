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
    let imageURL = "https://lh3.googleusercontent.com/p/AF1QipNvaaR6eoBC7I48N_-ROU30qsi_h2Sf5eQRxWtr=s1360-w1360-h1020"

    var body: some View {
        VStack {
            if loading {
                VStack {
                    Spacer()
                    ProgressView()
                        .foregroundStyle(.red)
                    Spacer()
                }
            } else {
                if business == nil {
                    VStack {
                        Spacer()
                        Text("Business details unavailable! Please try again later.")
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                } else {
                    VStack {
                        HStack {
                            Text(business?.location ?? "")
                                .font(.custom("FiraSans-Black", size: 50))
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
