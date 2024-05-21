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
    var combinedHours: [Timings]?

    enum CodingKeys: String, CodingKey {
        case location = "location_name"
        case hours, timings
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        hours = try values.decodeIfPresent([Hours].self, forKey: .hours)
        if let givenHours = hours {
            combinedHours = createTimingsDictionary(givenHours)
        }
    }
}
