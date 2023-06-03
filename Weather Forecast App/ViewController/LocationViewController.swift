//
//  LocationViewController.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 31/5/23.
//

import Foundation
import UIKit
import MapKit

protocol LocationViewControllerDelegate: AnyObject {
    func getCoordinate(latitude: Double?, longitude: Double?)
}

class LocationViewController: UIViewController {
    
    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    weak var delegate: LocationViewControllerDelegate?
    
    private var selectedLocation: CLLocationCoordinate2D?
    private var selectedPin: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select a location"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
           mapView.addGestureRecognizer(tapGesture)
    }
}
// MARK: - MapViewDelegate
extension LocationViewController: MKMapViewDelegate {
    @objc func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
         let touchPoint = gestureRecognizer.location(in: mapView)
         let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
         selectedLocation = coordinate
         
         // Remove the previous pin annotation if exists
         if let pin = selectedPin {
             mapView.removeAnnotation(pin)
         }
         
         // Add a new pin annotation
         let pin = MKPointAnnotation()
         pin.coordinate = coordinate
         mapView.addAnnotation(pin)
         selectedPin = pin
         
         print("Selected Location - Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)")
        delegate?.getCoordinate(latitude: coordinate.latitude, longitude: coordinate.longitude)
     }
}

extension LocationViewController: StoryboardBased {
    internal static var storyboardName: String {
        return "Main"
    }
}
