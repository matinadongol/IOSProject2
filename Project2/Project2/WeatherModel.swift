//
//  WeatherModel.swift
//  Project2
//
//  Created by Matina Dongol on 2023-07-28.
//

import Foundation

struct WeatherResponse: Decodable {
    let weatherData: WeatherData

    enum CodingKeys: String, CodingKey {
        case weatherData = "current"
    }
}

struct WeatherData: Decodable {
    let location: Location
    let current: CurrentWeather
}

struct Location: Decodable {
    let name: String
    let region: String
}

struct CurrentWeather: Decodable {
    let tempC: Double
    let condition: Condition

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition
    }
}

struct Condition: Decodable {
    let text: String
}
