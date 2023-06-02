//
//  SettingsViewController.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 2/6/23.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController {
    private let tableView = UITableView()
    private let viewMModel = SettingsViewModel()
    private let darkModeKey = Constants.shared.darkModeKey
    private let celsiusKey = Constants.shared.celsiusKey
    private let fehrenheitKey = Constants.shared.fahrenheitKey
    private let latitudeKey = Constants.shared.latitude
    private let longitudeKey = Constants.shared.longitude
    private let userDefaults = UserDefaultsManager.shared
    
    private var isDarkModelEnabled: Bool {
        get {
            if let value = userDefaults.value(forKey: darkModeKey ) as? Bool {
                return value
            }
            return false
        }
        set { userDefaults.set(value: newValue, forKey: darkModeKey) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func enableDarkMode() {
        UIApplication.shared.windows.forEach { window in
            if #available(iOS 13.0, *) {
                window.overrideUserInterfaceStyle = .dark
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func disableDarkMode() {
        UIApplication.shared.windows.forEach { window in
            if #available(iOS 13.0, *) {
                window.overrideUserInterfaceStyle = .light
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    private func handleNotification() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                self.sendNotification()
                print("Notification permission is enabled")
            } else {
                self.getNotificationPermission()
                print("Notification permission is not enabled")
            }
        }
        UNUserNotificationCenter.current().delegate = self
    }
    
    private func getNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }
    
   private func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Notification Title"
        content.body = "Notification Body"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
}

// MARK: - TableView Delegate & DataSource Methods
extension SettingsViewController:  UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewMModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewMModel.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewMModel.sections[indexPath.section][indexPath.row]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        switch cellType {
        default:
            cell.textLabel?.text = cellType.title
            if cellType  == .defaultLocation {
                if let lat = userDefaults.value(forKey: latitudeKey) as? Double,
                   let lon = userDefaults.value(forKey: longitudeKey) as? Double {
                    let latitude = String(format: "%.1f", lat)
                    let longitude = String(format: "%.1f", lon)
                    let location =  "lat:\(latitude) long: \(longitude)"
                    cell.detailTextLabel?.text = location
                }
            } else {
                cell.detailTextLabel?.text = cellType.detail
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellType = viewMModel.sections[indexPath.section][indexPath.row]
        switch cellType {
        case .celsius:
            userDefaults.set(value: true, forKey: celsiusKey)
            userDefaults.set(value: false, forKey: fehrenheitKey)
        case .fahrenheit:
            userDefaults.set(value: false, forKey: celsiusKey)
            userDefaults.set(value: true, forKey: fehrenheitKey)
        case .darkMode:
            isDarkModelEnabled.toggle()
            isDarkModelEnabled ? enableDarkMode() : disableDarkMode()
        case .defaultLocation:
            let locationVC = LocationViewController.instantiate()
            locationVC.delegate = self
            navigationController?.pushViewController(locationVC, animated: true)
        case .notificaation:
            handleNotification()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "Tempareture Units"
        } else if section == 1 { return "Mode"
        } else if section == 2 { return "Others"
        }
        return nil
    }
}

extension SettingsViewController: LocationViewControllerDelegate {
    func getCoordinate(latitude: Double?, longitude: Double?) {
        if let latitude = latitude, let longitude = longitude {
            userDefaults.set(value: latitude, forKey: self.latitudeKey)
            userDefaults.set(value: longitude, forKey: self.longitudeKey)
        }
    }
}

extension SettingsViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge,.sound])
    }
}
