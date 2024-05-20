//
//  Network.swift
//  TakeHome-Purs
//
//  Created by Anagha K J on 20/05/24.
//

import Alamofire
import Foundation

func getRequest(api: String) async throws -> Data? {
    return try await withCheckedThrowingContinuation { continuation in
        AF.request(api)
            .validate()
            .responseData { response in
                switch response.result {
                case let .success(data):
                    continuation.resume(returning: data)
                case .failure:
                    continuation.resume(returning: nil)
                }
            }
    }
}
