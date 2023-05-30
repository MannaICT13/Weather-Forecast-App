//
//  Environment.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 30/5/23.
//

import Foundation

class Environment {
    static let shared = Environment()
    var baseURL: URL
    private let devBaseURL = "http://api.openweathermap.org"
    private init() {
        baseURL = URL(string: devBaseURL)!
    }
}
