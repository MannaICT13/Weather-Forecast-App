//
//  AppManager.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 3/6/23.
//

import Foundation
import UIKit

class AppManager {
    static let shared = AppManager()
    var offlineVC: OfflineViewController?
    let reachability: Reachability!
    
    private init() {
        self.reachability = try! Reachability()
    }
    
    //MARK: - Reachability
    func startNotifyingReachability() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
            
            //Hide if it presenting
            if let offlineVC = self.offlineVC {
                self.offlineVC = nil
                offlineVC.dismiss(animated: true, completion: nil)
            }
        }
        
        reachability.whenUnreachable = { _ in
           print("Not reachable")
            let offlineVC = OfflineViewController()
            offlineVC.modalPresentationStyle = .fullScreen
            UIApplication.topViewController?.present(offlineVC, animated: false, completion: nil)
            self.offlineVC = offlineVC
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func removeUserDefaultsValue() {
        UserDefaultsManager.shared.removeValue(forKey: Constants.shared.darkModeKey)
        UserDefaultsManager.shared.removeValue(forKey: Constants.shared.celsiusKey)
        UserDefaultsManager.shared.removeValue(forKey: Constants.shared.fahrenheitKey)
    }
}

extension UIApplication {
    class var topViewController: UIViewController? { return getTopViewController() }
    private class func getTopViewController(base: UIViewController? = UIApplication.shared.windows.first{ (window) -> Bool in window.isKeyWindow}?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController { return getTopViewController(base: nav.visibleViewController) }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController { return getTopViewController(base: selected) }
        }
        if let presented = base?.presentedViewController { return getTopViewController(base: presented) }
        return base
    }
}
