//
//  ForecastFiveWeather.swift
//  WeatherApp
//
//  Created by Nino Chanturia on 2/6/21.
//

import Foundation

struct ForecastFiveResponse : Codable {
    let cod: String
    let message: Double
    let cnt: Int
    let list: [Forecast]
    let city: City
}

struct Forecast: Codable {
    let dt: Double
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Double
    let pop: Double
    let dt_txt: String
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coordinate
    let country: String
    let sunrise: Int64
    let sunset: Int64
}

struct DayForecast {
    var dayForecast: [Forecast]
    var weekDay: String
}

