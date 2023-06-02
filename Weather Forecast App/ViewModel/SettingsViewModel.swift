//
//  SettingsViewModel.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 2/6/23.
//

import Foundation
import Alamofire

extension SettingsViewModel {
    class Callback {
        var didSuccess: () -> Void = { }
        var didFailure: (AFError) -> Void = {_ in }
    }
}

class SettingsViewModel {
    private let userDefaults = UserDefaultsManager.shared
    private let appid: String = Constants.shared.locationKey
    private let units: String = Constants.shared.units
    
    let cityKey: String = Constants.shared.city
    let latitudeKey = Constants.shared.latitude
    let longitudeKey = Constants.shared.longitude
    let darkModeKey = Constants.shared.darkModeKey
    let celsiusKey = Constants.shared.celsiusKey
    let fehrenheitKey = Constants.shared.fahrenheitKey
    
    let callback = Callback()
    
    var cityResponse: CityResponse?
    
    var city: String {
        guard let cityName = cityResponse?.name else { return "Not Found" }
        return cityName
    }
    
    var coordinate: (Double, Double) {
        if let lat = userDefaults.value(forKey: latitudeKey) as? Double,
           let lon = userDefaults.value(forKey: longitudeKey) as? Double {
            return (lat, lon)
        }
        return (.zero, .zero)
    }
    
    var sections: [[Settings]] {
        var firstSection = [Settings]()
        firstSection = [.celsius, .fahrenheit]
        
        var secondSection = [Settings]()
        secondSection = [.darkMode]
        
        var thirdSection = [Settings]()
        thirdSection = [.defaultLocation, .notificaation]
        
        return [firstSection, secondSection, thirdSection]
    }
    
    func fetchCity() {
        WeatherAPIClient.fetchWeatherInfo(latitude: coordinate.0, longitude: coordinate.1, appid: appid, units: units) { [weak self] result in
            switch result {
            case .success(let response):
                self?.cityResponse = response.city
                self?.callback.didSuccess()
                
            case .failure(let error):
                self?.callback.didFailure(error)
            }
        }
    }
}


enum Settings: CaseIterable {
    case celsius
    case fahrenheit
    case darkMode
    case defaultLocation
    case notificaation
    
    var title: String {
        switch self {
        case .celsius: return "Celsius"
        case .fahrenheit: return "Fahrenheit"
        case .darkMode: return "Dark Mode"
        case .defaultLocation: return "Default Location"
        case .notificaation: return "Get Notify"
        }
    }
    
    var detail: String {
        switch self {
        case .celsius: return "°C"
        case .fahrenheit: return "°F"
        default: return ""
        }
    }
}
