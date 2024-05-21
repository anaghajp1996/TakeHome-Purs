//
//  FullScreenProgressIndicator.swift
//  TakeHome-Purs
//
//  Created by Anagha K J on 20/05/24.
//

import SwiftUI

struct FullScreenProgressIndicator: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
                .foregroundStyle(.red)
            Spacer()
        }
    }
}

#Preview {
    FullScreenProgressIndicator()
}
