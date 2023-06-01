//
//  WeatherViewController.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 30/5/23.
//

import UIKit

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
    override func viewDidLoad() {
        super.viewDidLoad()
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
            let (day, maxTemp, minTemp) = viewModel.firstFiveDays[indexPath.row]
            let temparature = "\(minTemp)°C/\(maxTemp)°C"

            let model = ForecastModel(temparature: temparature, dayName: day, imageStr: "cloudy2")
            cell.model = model

        return cell
    }
}
// MARK: - TableView  Delegate
extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView() as CustomHeaderView
        
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
        } else {
            // here current location
            viewModel.latitude = 22.457331
            viewModel.longitude = -0.127758
        }
    }
}
