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
            if let data = try await getRequest(api: "https://purs-demo-bucket-test.s3.us-west-2.amazonaws.com/location.json") {
                business = try JSONDecoder().decode(Business.self, from: data)
            }
        }
        catch {
            business = nil
        }
        return business
    }
}
