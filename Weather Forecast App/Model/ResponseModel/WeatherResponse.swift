//
//  WeatherResponse.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 30/5/23.
//

import Foundation

// MARK: - List
struct WeatherResponseList: Codable {
    let dt: Int?
    let main: MainClass?
    let weather: [Weather]?
    let clouds: Clouds?
    let wind: Wind?
    let visibility, pop: Int?
    let sys: Sys?
    let dtTxt: String?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, seaLevel, grndLevel, humidity: Int?
    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let pod: Pod?
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let main: String?
    let description: Description?
    let icon: String?
}

enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}


struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coordinate?
    let country: String?
    let population: Int?
    let timezone: Int?
    let sunrise: Int?
    let sunset: Int?
}

struct Coordinate: Codable {
    let lat: Double?
    let lon: Double?
}

struct ClimetResponse: Codable {
    var city: City?
    var list: WeatherResponseList?
}
