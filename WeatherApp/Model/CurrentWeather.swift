//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Nino Chanturia on 2/6/21.
//

import Foundation
struct CurrentWeatherResponse: Codable {
    let coord: Coordinate
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Double
    let wind: Wind
    let clouds: Clouds
    let dt: Double
    let sys: Sys
    let id: Int64
    let name: String
    let cod: Int
}

struct Coordinate: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int64
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Int
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

struct Clouds: Codable {
    let all: Int
}

struct Sys: Codable {
    let type: Int
    let id: Int
    let message: Double?
    let country: String
    let sunrise: Int64
    let sunset: Int64
}

