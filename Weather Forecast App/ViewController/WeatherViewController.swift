//
//  WeatherViewController.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 30/5/23.
//

import UIKit
import Foundation

class WeatherViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.registerNibHeaderFooter(CustomHeaderView.self)
            tableView.registerNibCell(ForecastCell.self)
        }
    }
    
    let viewModel = WeatherViewModel()
   // let weatherColor = WeatherCondition.sunny
    let locationManager = LocationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.startUpdatingLocation()
        updateUserCurrentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchWeatherInfo()
        viewModel.callback.didSuccess = {[weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.callback.didFailure = {[weak self] error in
            print(error)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    func setBackgroundBasedOnWeather(weather: WeatherCondition ) -> UIColor {
        let backgroundColor: UIColor
        
        switch weather {
        case .sunny:
            backgroundColor = .sunnyBackgroundColor
        case .rainy:
            backgroundColor = .rainyBackgroundColor
        case .cloudy:
            backgroundColor = .cloudyBackgroundColor
        }
        return backgroundColor
    }
    
    func showLocationAccessAlert() {
        let alert = UIAlertController(title: "Location Access", message: "Please grant location access to use this feature.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        alert.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func updateUserCurrentLocation() {
        if let lastLocation = locationManager.lastKnownLocation {
            let latitude = lastLocation.coordinate.latitude
            let longitude = lastLocation.coordinate.longitude
            viewModel.latitude = latitude
            viewModel.longitude = longitude
            print("Latitude: \(latitude), Longitude: \(longitude)")
        } else {
            print("Location not available")
        }
    }
}

// MARK: - TableView DataSource & Delegate
extension WeatherViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.firstFiveDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ForecastCell.deque(for: tableView, at: indexPath)
        let (day,icon, maxTemp, minTemp) = viewModel.firstFiveDays[indexPath.row]
        let min = String(format: "%.2f", minTemp)
        let max = String(format: "%.2f", maxTemp)
        
        let temparature = "\(min)°C / \(max)°C"
        
        let model = ForecastModel(temparature: temparature, dayName: day, imageStr: icon)
        cell.model = model
        
        return cell
    }
}
// MARK: - TableView  Delegate
extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView() as CustomHeaderView
        headerView.tintColor = setBackgroundBasedOnWeather(weather: viewModel.weatherCondition)
        view.backgroundColor = setBackgroundBasedOnWeather(weather: viewModel.weatherCondition)
        navigationController?.navigationBar.barTintColor = setBackgroundBasedOnWeather(weather: viewModel.weatherCondition)
        headerView.model = viewModel.model
        headerView.callback.didTappedMap = {[weak self] in
            let locationVC = LocationViewController.instantiate()
            locationVC.delegate = self
            self?.navigationController?.pushViewController(locationVC, animated: true)
        }
        
        headerView.callback.didTappedSetting = {[weak self] in
            //navigate to setting vc
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 226.0
    }
}

extension WeatherViewController: LocationViewControllerDelegate {
    func getCoordinate(latitude: Double?, longitude: Double?) {
        if let latitude = latitude, let longitude = longitude {
            viewModel.latitude = latitude
            viewModel.longitude = longitude
        }
    }
}
