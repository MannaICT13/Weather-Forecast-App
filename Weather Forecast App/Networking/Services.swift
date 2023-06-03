//
//  Services.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 30/5/23.
//

import Foundation
import Alamofire

private struct WeatherRoute: APIRouteable {
    
    var baseURL: String = Environment.shared.baseURL.absoluteString
    var path: String = "/data/2.5/forecast"
    var method: HTTPMethod = .get
    var parameters: Parameter?
    
    struct Parameter: Codable {
        let latitude: Double
        let longitude: Double
        let appid: String
        let units: String
        
        enum CodingKeys: String, CodingKey {
            case latitude = "lat"
            case longitude = "lon"
            case appid
            case units
        }
    }
    
    init(parameters: Parameter) {
        self.parameters = parameters
    }
}

enum WeatherAPIClient: GenericAPIClient {
    static func fetchWeatherInfo(latitude: Double, longitude: Double, appid: String, units: String, completion: @escaping(Result<NetworkResponse<[WeatherResponse], CityResponse>, AFError>) -> Void) {
        let parameter = WeatherRoute.Parameter(latitude: latitude, longitude: longitude, appid: appid, units: units)
        let route = WeatherRoute(parameters: parameter)
        startRequest(with: route, completion: completion)
    }
}
