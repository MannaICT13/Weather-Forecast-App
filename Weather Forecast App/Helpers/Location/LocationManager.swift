//
//  LocationManager.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 2/6/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    
    var lastKnownLocation: CLLocation? {
          return locationManager.location
      }
    
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func checkLocationAuthorization() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            // Location access is already granted
            break
        case .denied, .restricted:
            // Handle location access denied or restricted case
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    func startUpdatingLocation() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                if CLLocationManager.locationServicesEnabled() {
                    self.locationManager.startUpdatingLocation()
                } else {
                    // Handle location services not enabled case
                }
            }
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingHeading()
    }

    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        
        // Use the latitude and longitude values as needed
        print("Latitude: \(latitude), Longitude: \(longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle any location update errors
    }
}
