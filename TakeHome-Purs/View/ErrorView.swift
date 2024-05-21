//
//  ErrorView.swift
//  TakeHome-Purs
//
//  Created by Anagha K J on 20/05/24.
//

import SwiftUI

struct ErrorView: View {
    var title: String
    var body: some View {
        VStack {
            Spacer()
            Text(title)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ErrorView(title: "Error View")
}
