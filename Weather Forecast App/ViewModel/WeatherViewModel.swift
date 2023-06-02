//
//  WeatherViewModel.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 30/5/23.
//

import Foundation
import Alamofire

enum WeatherCondition {
    case sunny
    case rainy
    case cloudy
}

enum TemperatureUnits: String, CaseIterable {
    case celsius = "C"
    case fahrenheit = "F"
}

extension WeatherViewModel {
    class Callback {
        var didSuccess: () -> Void = { }
        var didFailure: (AFError) -> Void = {_ in }
    }
}

class WeatherViewModel {
    
    var latitude: Double = .zero
    var longitude: Double = .zero
    
    let appid: String = Constants.shared.locationKey
    let units: String = Constants.shared.units
    
    let callback = Callback()
    
    var weatherResponse: [WeatherResponse] = []
    var temperatureUnit: TemperatureUnits  = .celsius
    
    private var id: Int {
        return weatherResponse.first?.weather?.first?.id ?? .zero
    }
    
    private var imageStr: String {
        return updateWeatherIcon(id: id)
    }
    
    private var temparature: String {
        let temp = weatherResponse.first?.main?.temp ?? .zero
        var output: String = ""
        var newValue: Double = .zero
        
        if let degreeSymbol = "\u{00B0}".unicodeScalars.first {
            let degreeString = String(degreeSymbol)
            if temperatureUnit == .fahrenheit {
                newValue = celsiusToFahrenheit(celsius: temp)
            } else {
                newValue = temp
            }
            let temperatureString = String(format: "%.1f", newValue)
            
            output = temperatureString + degreeString + temperatureUnit.rawValue
        }
        return output
    }
    
    private var weatherInfo: String {
        return weatherResponse.first?.weather?.first?.main ?? ""
    }
    
    var weatherCondition: WeatherCondition {
        return updateWeatherCondition(id: id)
    }
    
    var model: CustomViewModel? {
        let model = CustomViewModel(title: "Dhaka", foreCastImageName: imageStr, tempareture: temparature, weatherInfo: weatherInfo)
        return model
    }
    
    var firstFiveDays: [(String, String, Double, Double)] {
        var uniqueDates: Set<String> = []
        var firstFiveDays: [(String, String, Double, Double)] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        for listItem in weatherResponse {
            let id = listItem.weather?.first?.id ?? .zero
            let temperature = listItem.main?.temp ?? .zero
            var tempMax = listItem.main?.tempMax ?? .zero
            var tempMin = listItem.main?.tempMin ?? .zero
            let dateString = listItem.dtTxt
            
            guard let date = dateFormatter.date(from: dateString ?? "") else {
                continue
            }
            
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "yyyy-MM-dd"
            
            let dayNameFormatter = DateFormatter()
            dayNameFormatter.dateFormat = "EEEE"
            
            let currentDate = Date()
            let key = dayFormatter.string(from: date)
            var day = dayNameFormatter.string(from: date)
            
            if uniqueDates.contains(key) {
                continue
            }
            
            uniqueDates.insert(key)
            
            if Calendar.current.isDateInToday(date) {
                day = "Today"
            }
            let icon = updateWeatherIcon(id: id)
            
            if temperatureUnit == .fahrenheit {
                tempMax = celsiusToFahrenheit(celsius: tempMax)
                tempMin = celsiusToFahrenheit(celsius: tempMin)
            }
            
            firstFiveDays.append((day,icon, tempMax, tempMin))
            
            if firstFiveDays.count == 5 {
                break
            }
        }
        return firstFiveDays
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
    
    private func updateWeatherCondition(id: Int) -> WeatherCondition {
        switch(id) {
        case 0...300 : return .sunny
        case 301...700 : return .rainy
        case 701...771 : return .cloudy
        case 772...799 : return .rainy
        case 800 : return .sunny
        case 801...804 : return .cloudy
        case 900...903, 905...1000 : return .rainy
        case 903 : return .rainy
        case 904 : return .sunny
        default :
            return .sunny
        }
    }
    
    private func celsiusToFahrenheit(celsius: Double) -> Double {
        let fahrenheit = (celsius * 9/5) + 32
        return fahrenheit
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
