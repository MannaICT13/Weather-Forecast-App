//
//  NetworkResponse.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 30/5/23.
//

import Foundation

struct NetworkResponse<T: Codable, N: Codable>: Codable {
    var cod: String
    var message: Int
    var cnt: Int
    var list: T
    var city: N
}
