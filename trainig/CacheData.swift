//
//  cache.swift
//  trainig
//
//  Created by omer yildirim on 11.02.2025.
//

import Foundation

public class CacheData {
    static let cacheKey = "token"
    static let expiryKey = "tokenExpireDate"
    static let userDataKey = "userData"
    static let hasNotificationKey = "hasNotification"
    

    public static func saveToken(data: String, duration: TimeInterval) {
        let expiryDate = Date().addingTimeInterval(duration)
        UserDefaults.standard.set(data, forKey: cacheKey)
        UserDefaults.standard.set(expiryDate, forKey: expiryKey)
    }
    public static func getToken() -> String? {
        guard let expiryDate = UserDefaults.standard.object(forKey: expiryKey) as? Date,
              expiryDate > Date() else {
            UserDefaults.standard.removeObject(forKey: cacheKey)
            UserDefaults.standard.removeObject(forKey: expiryKey)
            return nil
        }
        return UserDefaults.standard.string(forKey: cacheKey)
    }
    
    public static func saveUserData(data: NSMutableDictionary) {
        UserDefaults.standard.set(data, forKey: userDataKey)
    }
    public static func getUserData() -> NSMutableDictionary? {
        if let d = UserDefaults.standard.object(forKey: userDataKey) as? NSDictionary {
            let mutableDict = NSMutableDictionary(dictionary: d)
            return mutableDict
        }
        return nil
    }
    public static func saveHasNotification() {
        UserDefaults.standard.set(true, forKey: hasNotificationKey)
    }
    public static func hasNotification() -> Bool? {
        return UserDefaults.standard.bool(forKey: hasNotificationKey)
    }
    
}
