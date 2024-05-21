//
//  Hours.swift
//  TakeHome-Purs
//
//  Created by Anagha K J on 21/05/24.
//

import Foundation

struct Hours: Decodable, Hashable {
    var dayOfWeek: String?
    var startTime: Date?
    var endTime: Date?

    enum CodingKeys: String, CodingKey {
        case dayOfWeek = "day_of_week"
        case startTime = "start_local_time"
        case endTime = "end_local_time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dayOfWeek = try values.decodeIfPresent(String.self, forKey: .dayOfWeek)
        if let startTimeString = try values.decodeIfPresent(String.self, forKey: .startTime),
           let endTimeString = try values.decodeIfPresent(String.self, forKey: .endTime)
        {
            startTime = convertToDate(startTimeString)
            endTime = convertToDate(endTimeString)
        }
    }
}

struct Timings: Hashable {
    var day: String
    var timeRanges: [TimeRange]
}

struct TimeRange: Hashable {
    var startTime: Date
    var endTime: Date
    // String representation of the hours range
    var rangeString: String
}

// Timings specific utilities

// Function to combine DAYS
func createTimingsDictionary(_ hours: [Hours]) -> [Timings] {
    var timings = [Timings]()
    var dictionary = [String: [(Date, Date)]]()
    let keys = Set(hours.map { $0.dayOfWeek })
    for key in keys {
        if let key = key {
            var values: [(Date, Date)] = []
            for hour in hours {
                if hour.dayOfWeek == key {
                    if let startTime = hour.startTime, let endTime = hour.endTime {
                        values.append((startTime, endTime))
                    }
                }
            }
            dictionary[key] = values
        }
    }
    timings = dictionary.map { Timings(day: dayOfWeek[$0.key] ?? "",
                                       timeRanges: $0.value.map {
                                           let startTime = convertDateToString($0.0)
                                           let endTime = convertDateToString($0.1)
                                           let rangeString = startTime == endTime ? "Open 24hrs" : "\(startTime) - \(endTime)"
                                           return TimeRange(startTime: $0.0, endTime: $0.1, rangeString: rangeString)
                                       }) }
    for var timing in timings {
        timing.timeRanges = combineTimeRanges(timing.timeRanges)
    }
    return timings
}

// Function to combine hours of a particular day
func combineTimeRanges(_ ranges: [TimeRange]) -> [TimeRange] {
    let sortedTimes = ranges.sorted(by: { Calendar.current.component(.hour, from: $0.startTime) < Calendar.current.component(.hour, from: $1.startTime) })
    var combinedTimes: [TimeRange] = []
    if !sortedTimes.isEmpty {
        for index in 0 ... sortedTimes.count - 1 {
            if index < sortedTimes.count - 1 {
                // Check 2 time ranges can be combined
                if Calendar.current.component(.hour, from: sortedTimes[index].endTime) ==
                    Calendar.current.component(.hour, from: sortedTimes[index + 1].startTime) {
                    let startTime = sortedTimes[index].startTime
                    let endTime = sortedTimes[index + 1].endTime
                    let rangeString = startTime == endTime ? "Open 24hrs" : "\(startTime) - \(endTime)"
                    combinedTimes.append(TimeRange(startTime: sortedTimes[index].startTime,
                                                   endTime: sortedTimes[index + 1].endTime,
                                                   rangeString: rangeString))
                } else {
                    combinedTimes.append(sortedTimes[index])
                }
            }
        }
    }
    return combinedTimes
}
