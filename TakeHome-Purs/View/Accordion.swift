//
//  Accordion.swift
//  TakeHome-Purs
//
//  Created by Anagha K J on 20/05/24.
//

import SwiftUI

struct Accordion: View {
    @Binding var collapseAccordion: Bool
    var timings: [Timings]

    var body: some View {
        let isOpen = checkIfOpenNow(timings: timings)
        VStack {
            Button(
                action: {
                    withAnimation {
                        collapseAccordion.toggle()
                    }
                },
                label: {
                    VStack(alignment: .leading) {
                        HStack {
                            HStack {
                                Text(getOpeningHourTitle(for: timings))
                                    .font(.custom(Constants.HindSiliguriReg, size: 18))
                                Circle()
                                    .fill(isOpen.0 ? isOpen.1 ? .yellow : .green : .red)
                                    .frame(width: 7, height: 7)
                            }
                            Spacer()
                            Image(systemName: collapseAccordion ? "chevron.down" : "chevron.up")
                        }
                        .contentShape(Rectangle())
                        Text("See full hours")
                            .font(.custom(Constants.ChivoReg, size: 12))
                            .textCase(.uppercase)
                            .foregroundStyle(.accordionSubtitle)
                            .shadow(color: .white, radius: 20)
                    }
                    .padding()
                }
            )
            .buttonStyle(PlainButtonStyle())
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                }
                Divider()
                    .foregroundStyle(.black.opacity(0.25))
                    .padding(.horizontal)
                List(timings, id: \.self) { timing in
                    let rangeString = timing.timeRanges.map { $0.rangeString }.joined(separator: ",\n")
                    HStack(alignment: .top) {
                        Text(timing.day)
                        Spacer()
                        Text(rangeString)
                            .frame(width: 150)
                            .multilineTextAlignment(.trailing)
                    }
                    .font(.custom(Constants.HindSiliguriReg, size: 18))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }

                .listStyle(.plain)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapseAccordion ? 0 : 250)
            .transition(.slide)
        }
    }
}
