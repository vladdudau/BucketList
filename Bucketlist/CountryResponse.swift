//
//  Created by user215924 on 5/1/22.
//
import Foundation

// MARK: - CountryResponse
struct CountryResponse: Codable {
    let results: [Result]
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case results
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Result: Codable {
    let components: Components
    let confidence: Int
}

// MARK: - Components
struct Components: Codable {
    let country: String
}

