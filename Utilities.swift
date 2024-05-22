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
    dateFormatter.dateFormat = "h:mma"
    dateFormatter.amSymbol = "AM"
    dateFormatter.pmSymbol = "PM"
    return dateFormatter.string(from: date)
}

func getDay(from date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter.string(from: date)
}

func getCurrentHourOf(_ date: Date) -> Int {
    let currentHour = Calendar.current.component(.hour, from: date)
    return currentHour
}

func checkIfOpenNow(timings: [Timings]) -> (Bool, Bool) {
    // Current day's opening hours
    let openHours = timings.first(where: { $0.day == getDay(from: Date.now) })
    let currentHour = getCurrentHourOf(Date.now)
    var isClosingSoon = false
    let isOpenNow = openHours?.timeRanges.contains(where: {
        let startTime = getCurrentHourOf($0.startTime)
        let endTime = getCurrentHourOf($0.endTime)
        // Is current time within opening hours?
        let isOpen = startTime <= currentHour && currentHour <= endTime
        if isOpen {
            // If business is open, is it closing soon?
            isClosingSoon = endTime - currentHour <= 1
        }
        return isOpen
    })
    return (isOpenNow ?? false, isClosingSoon)
}

func getOpeningHourTitle(for timings: [Timings]) -> String {
    var title = ""
    let now = Date.now
    let currentDay = getDay(from: now)
    let currentHour = getCurrentHourOf(now)
    var openUntil: Date?
    var opensNextAt: Date?

    // If open now-
    let openHours = timings.first(where: { $0.day == currentDay })

    if let currentOpenRange = openHours?.timeRanges.first(where: {
        let startTime = getCurrentHourOf($0.startTime)
        let endTime = getCurrentHourOf($0.endTime)
        // Is current time within opening hours?
        return startTime <= currentHour && currentHour <= endTime
    }) {
        // Is open now.
        openUntil = currentOpenRange.endTime
    } else {
        // Opens next at, on the same day
        opensNextAt = timings.first(where: { $0.day == currentDay })?.timeRanges.first(where: {
            let startTime = getCurrentHourOf($0.startTime)
            // Next opening hour of the day
            return startTime > currentHour
        })?.startTime
        if opensNextAt == nil {
            // Get next day's opening hours; adding interval 86400 to get tomorrow's day
            if let openHours = openHours {
                let nextOpenDay = timings[timings.index(after: timings.firstIndex(of: openHours) ?? 0)]
                opensNextAt = nextOpenDay.timeRanges.first?.startTime
                if let opensNextAt = opensNextAt {
                    title = "Opens \(nextOpenDay.day) at \(convertDateToString(opensNextAt))"
                }
            }

            let nextOpenDay = timings.first(where: { $0.day == getDay(from: now.addingTimeInterval(86400)) })
            opensNextAt = nextOpenDay?.timeRanges.first?.startTime
            if let opensNextAt = opensNextAt {
                title = "Opens \(nextOpenDay?.day ?? "") at \(convertDateToString(opensNextAt))"
            }
        } else {
            title = "Reopens at \(convertDateToString(opensNextAt!))"
        }
    }

    if let openUntil = openUntil {
        if let opensNextAt = opensNextAt {
            title = "Open until \(convertDateToString(openUntil)), reopens at \(convertDateToString(opensNextAt))"
        } else {
            title = "Open until \(convertDateToString(openUntil))"
        }
    } else if let opensNextAt = opensNextAt {
        if title.isEmpty {
            title = "Opens \(getDay(from: opensNextAt)) at \(convertDateToString(opensNextAt))"
        }
    }
    return title
}
