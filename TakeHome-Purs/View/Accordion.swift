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

    func getCurrentDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: Date.now)
    }

    func getCurrentHourOf(_ date: Date) -> Int {
        let currentHour = Calendar.current.component(.hour, from: date)
        return currentHour
    }

    func checkIfOpenNow() -> (Bool, Bool) {
        // Current day's opening hours
        let openHours = timings.first(where: { $0.day == getCurrentDay() })
        let currentHour = getCurrentHourOf(Date.now)
        var isClosingSoon = false
        let isOpenNow = openHours?.timeRanges.contains(where: {
            let startTime = getCurrentHourOf($0.startTime)
            let endTime = getCurrentHourOf($0.endTime)
            // Is current time within opening hours?
            let isOpen = startTime < currentHour && currentHour < endTime
            if isOpen {
                // If business is open, is it closing soon?
                isClosingSoon = endTime - currentHour <= 1
            }
            return isOpen
        })
        return (isOpenNow ?? false, isClosingSoon)
    }

    var body: some View {
        let isOpen = checkIfOpenNow()
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
                                Text("title here")
                                    .font(.custom(Constants.HindSiliguriReg, size: 18))
                                Circle()
                                    .fill(isOpen.0 ? isOpen.1 ? .yellow : .green : .red)
                                    .frame(width: 7, height: 7)
                            }
                            Spacer()
                            Image(systemName: collapseAccordion ? "chevron.down" : "chevron.up")
                        }
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
