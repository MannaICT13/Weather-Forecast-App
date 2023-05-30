//
//  WeatherViewModel.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 30/5/23.
//

import Foundation

class WeatherViewModel {
    
    let latitude: String = "22.457331"
    let longitude: String = "-0.127758"
    let appid: String = "0d0c15cd1f4d893cca83a6b0061bbccb"
    let units: String = "metric"
    
    
    func fetchWeatherInfo() {
        WeatherAPIClient.fetchWeatherInfo(latitude: latitude, longitude: longitude, appid: appid, units: units) { [weak self] result in
            
            switch result {
            case .success(let response):
                if response.list.count > .zero {
                    print(response.list)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
