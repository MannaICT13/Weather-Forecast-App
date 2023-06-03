//
//  AppDelegate.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 30/5/23.
//


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppManager.shared.startNotifyingReachability()
        AppManager.shared.removeUserDefaultsValue()
        LocationManager.shared.checkLocationAuthorization()
        return true
    }
}

