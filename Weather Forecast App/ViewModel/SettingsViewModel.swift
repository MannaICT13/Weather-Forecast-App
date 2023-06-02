//
//  SettingsViewModel.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 2/6/23.
//

import Foundation

class SettingsViewModel {
    
    var defaultLatitude = Double()
    var defaultLongitude = Double()
    
    var sections: [[Settings]] {
        var firstSection = [Settings]()
        firstSection = [.celsius, .fahrenheit]
        
        var secondSection = [Settings]()
        secondSection = [.darkMode]
        
        var thirdSection = [Settings]()
        thirdSection = [.defaultLocation, .notificaation]
        
        return [firstSection, secondSection, thirdSection]
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
