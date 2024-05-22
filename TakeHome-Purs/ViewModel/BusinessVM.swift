//
//  BusinessVM.swift
//  TakeHome-Purs
//
//  Created by Anagha K J on 20/05/24.
//

import Foundation

class BusinessVM {
    func getBusinessDetails() async -> Business? {
        var business: Business?
        do {
//            if let data = try await getRequest(api: "https://purs-demo-bucket-test.s3.us-west-2.amazonaws.com/location.json") {
                let json = """
                {
                    "location_name": "BEASTRO by Marshawn Lynch",
                    "hours": [
                        {
                            "day_of_week": "FRI",
                            "start_local_time": "07:00:00",
                            "end_local_time": "13:00:00"
                        },
                        {
                            "day_of_week": "FRI",
                            "start_local_time": "13:00:00",
                            "end_local_time": "02:00:00"
                        },
                        {
                            "day_of_week": "WED",
                            "start_local_time": "15:00:00",
                            "end_local_time": "22:00:00"
                        },
                        {
                            "day_of_week": "TUE",
                            "start_local_time": "07:00:00",
                            "end_local_time": "19:00:00"
                        },
                        {
                            "day_of_week": "TUE",
                            "start_local_time": "21:00:00",
                            "end_local_time": "23:00:00"
                        },
                        {
                            "day_of_week": "THU",
                            "start_local_time": "00:00:00",
                            "end_local_time": "24:00:00"
                        }
                    ]
                }
                """
                let jsonData = json.data(using: .utf8)!
                business = try JSONDecoder().decode(Business.self, from: jsonData)
//            }
        }
        catch {
            business = nil
        }
        return business
    }
}
