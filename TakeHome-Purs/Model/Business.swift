//
//  Business.swift
//  TakeHome-Purs
//
//  Created by Anagha K J on 20/05/24.
//

import Foundation

struct Business: Decodable {
    var location: String?
    var hours: [Hours]?
    var timings: [Timings]?

    enum CodingKeys: String, CodingKey {
        case location = "location_name"
        case hours, timings
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        hours = try values.decodeIfPresent([Hours].self, forKey: .hours)
        if let givenHours = hours {
            timings = createTimingsDictionary(givenHours)
        }
    }
}

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
    var timings: [TimeRange]
}

struct TimeRange: Hashable {
    var startTime: Date
    var endTime: Date
    var rangeString: String
}

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
                                       timings: $0.value.map {
                                           let startTime = convertDateToString($0.0)
                                           let endTime = convertDateToString($0.1)
                                           let rangeString = startTime == endTime ? "Open 24hrs" : "\(startTime) - \(endTime)"
                                           return TimeRange(startTime: $0.0, endTime: $0.1, rangeString: rangeString)
                                       }) }
    for var timing in timings {
        timing.timings = combineTimeRanges(timing.timings)
    }
    return timings
}

func combineTimeRanges(_ ranges: [TimeRange]) -> [TimeRange] {
    let sortedTimes = ranges.sorted(by: { $0.startTime < $1.startTime })
    var combinedTimes: [TimeRange] = []
    if !sortedTimes.isEmpty {
        for index in 0 ... sortedTimes.count - 1 {
            if index < sortedTimes.count - 1 {
                if sortedTimes[index].endTime == sortedTimes[index + 1].startTime {
                    let startTime = sortedTimes[index].startTime
                    let endTime = sortedTimes[index + 1].endTime
                    let rangeString = startTime == endTime ? "Open 24hrs" : "\(startTime) - \(endTime)"
                    combinedTimes.append(TimeRange(startTime: sortedTimes[index].startTime,
                                                   endTime: sortedTimes[index + 1].endTime,
                                                   rangeString: rangeString))
                }
            }
        }
    }

    return combinedTimes.isEmpty ? sortedTimes : combinedTimes
}
