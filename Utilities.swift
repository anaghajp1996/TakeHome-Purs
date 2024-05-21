//
//  Utilities.swift
//  TakeHome-Purs
//
//  Created by Anagha K J on 20/05/24.
//

import Foundation

func convertToDate(_ string: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss"
    if string == "24:00:00" {
        if let midnight = dateFormatter.date(from: "23:59:59") {
            return Calendar.current.date(byAdding: .second, value: 1, to: midnight)
        }
    }
    return dateFormatter.date(from: string)
}

func convertDateToString(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "ha"
    dateFormatter.amSymbol = "AM"
    dateFormatter.pmSymbol = "PM"
    return dateFormatter.string(from: date)
}

