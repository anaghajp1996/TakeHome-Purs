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

    enum CodingKeys: String, CodingKey {
        case location = "location_name"
        case hours
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        hours = try values.decodeIfPresent([Hours].self, forKey: .hours)
    }
}

struct Hours: Decodable, Hashable {
    var dayOfWeek: String?
    var startTime: String?
    var endTime: String?

    enum CodingKeys: String, CodingKey {
        case dayOfWeek = "day_of_week"
        case startTime = "start_local_time"
        case endTime = "end_local_time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dayOfWeek = try values.decodeIfPresent(String.self, forKey: .dayOfWeek)
        startTime = try values.decodeIfPresent(String.self, forKey: .startTime)
        endTime = try values.decodeIfPresent(String.self, forKey: .endTime)
    }
}
