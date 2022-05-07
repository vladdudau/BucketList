import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let list: [WeatherListItem]
}

// MARK: - List
struct WeatherListItem: Codable {
    let id = UUID().self
    let main: MainClass
    let dtTxt: Date
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case main
        case dtTxt = "dt_txt"
        case weather
    }

}

// MARK: - MainClass
struct MainClass: Codable {
    let temp: Double
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case humidity
    }
}


// MARK: - Weather
struct Weather: Codable {
    let weatherDescription: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        case icon
    }
}



