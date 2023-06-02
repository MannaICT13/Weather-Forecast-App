//
//  UserDefaultsManager.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 2/6/23.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    func set(value: Any?, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func value(forKey key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    
    func removeValue(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
