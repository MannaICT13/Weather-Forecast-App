//
//  WeatherViewController.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 30/5/23.
//

import UIKit

class WeatherViewController: UIViewController {
    
    let viewModel = WeatherViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchWeatherInfo()
    }
}

