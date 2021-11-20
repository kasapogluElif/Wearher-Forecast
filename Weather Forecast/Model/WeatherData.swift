//
//  WeatherData.swift
//  Weather Forecast
//
//  Created by Elif Kasapoglu on 12.11.2021.
//

import Foundation
struct WeatherData : Codable{
    let lat: Double
    let lon: Double
    let current: Current
    let hourly: [Hourly]
}

struct Current : Codable{
    let temp: Double
    let weather : [Weather]
}

struct Hourly : Codable{
    let dt: Double
    let temp: Double
    let weather : [Weather]
}

struct Weather : Codable{
    let id: Int
    let description : String
}
