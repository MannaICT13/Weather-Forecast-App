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
    
    let refreshControl = UIRefreshControl()
    
    let viewModel = WeatherViewModel()
    let locationManager = LocationManager.shared
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.startUpdatingLocation()
        updateUserCurrentLocation()
        view.addSubview(blurEffectView)
        tableView.refreshControl = refreshControl
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.contentView.addSubview(activityIndicator)
        activityIndicator.center = blurEffectView.contentView.center
        activityIndicator.hidesWhenStopped = true
        startLoading()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchWeatherInfo()
        viewModel.callback.didSuccess = {[weak self] in
            self?.stopLoading()
            self?.tableView.reloadData()
            self?.endRefreshing()
        }
        viewModel.callback.didFailure = {[weak self] error in
            self?.stopLoading()
            self?.endRefreshing()
            print(error)
        }
        
        if let isCelsius = UserDefaultsManager.shared.value(forKey: Constants.shared.celsiusKey) as? Bool {
            if isCelsius {
                viewModel.temperatureUnit = .celsius
            }
        }
        if let isFehrenheit = UserDefaultsManager.shared.value(forKey: Constants.shared.fahrenheitKey) as? Bool {
            if isFehrenheit {
                viewModel.temperatureUnit = .fahrenheit
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    @objc func refreshData() {
        updateUserCurrentLocation()
        viewModel.fetchWeatherInfo()
    }
    
    private func endRefreshing() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func startLoading() {
        blurEffectView.isHidden = false
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    func stopLoading() {
        blurEffectView.isHidden = true
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
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
        let unit = viewModel.temperatureUnit.rawValue
        let temparature = "\(min)°\(unit) / \(max)°\(unit)"
        
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
            let settingsVC = SettingsViewController()
            self?.navigationController?.pushViewController(settingsVC, animated: true)
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
