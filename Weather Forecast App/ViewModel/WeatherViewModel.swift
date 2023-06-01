//
//  WeatherViewModel.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 30/5/23.
//

import Foundation
import Alamofire

extension WeatherViewModel {
    class Callback {
        var didSuccess: () -> Void = { }
        var didFailure: (AFError) -> Void = {_ in }
    }
}

class WeatherViewModel {
    
    var latitude: Double = .zero
    var longitude: Double = .zero
    let appid: String = "0d0c15cd1f4d893cca83a6b0061bbccb"
    let units: String = "metric"
    
    let callback = Callback()
    
    var weatherResponse: [WeatherResponse] = []
    
    private var id: Int {
        return weatherResponse.first?.weather?.first?.id ?? .zero
    }
    
    private var imageStr: String {
        return updateWeatherIcon(id: id)
    }
    
    private var temparature: String {
        let temp = weatherResponse.first?.main?.temp ?? .zero
        var output: String = ""
        if let degreeSymbol = "\u{00B0}".unicodeScalars.first {
            let degreeString = String(degreeSymbol)
            let temperatureString = String(format: "%.1f", temp)
            
            output = temperatureString + degreeString + "C"
        }
        return output
    }
    
    
    private var weatherInfo: String {
        return weatherResponse.first?.weather?.first?.main ?? ""
    }
    
    var model: CustomViewModel? {
        let model = CustomViewModel(title: "Dhaka", foreCastImageName: imageStr, tempareture: temparature, weatherInfo: weatherInfo)
        return model
    }
    
    private func updateWeatherIcon(id: Int) -> String {
    switch (id) {
        case 0...300 : return "tstorm1"
        case 301...500 : return "light_rain"
        case 501...600 : return "shower3"
        case 601...700 : return "snow4"
        case 701...771 : return "fog"
        case 772...799 : return "tstorm3"
        case 800 : return "sunny"
        case 801...804 : return "cloudy2"
        case 900...903, 905...1000 : return "tstorm3"
        case 903 : return "snow5"
        case 904 : return "sunny"
        default :
            return "dunno"
        }
    }
    
    func fetchWeatherInfo() {
        WeatherAPIClient.fetchWeatherInfo(latitude: latitude, longitude: longitude, appid: appid, units: units) { [weak self] result in
            switch result {
            case .success(let response):
                if response.list.count > .zero {
                    self?.weatherResponse = response.list
                    self?.callback.didSuccess()
                    print(response.list)
                }
            case .failure(let error):
                self?.callback.didFailure(error)
                print(error)
            }
        }
    }
}
