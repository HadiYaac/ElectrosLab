//
//  StorageManager.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 7/2/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import Foundation

enum StorageKeys: String {
    case user = "kUser"
}

struct StorageManager {
    static let jsonEncoder = JSONEncoder()
    static let jsonDecoder = JSONDecoder()
    static let userDefaults = UserDefaults.standard
    
    private static var currentUser: ELUser?
    
    static func getCurrentUser() -> ELUser? {
        if let user = currentUser {
            return user
        } else {
            let userData = userDefaults.data(forKey: StorageKeys.user.rawValue)
            if let data = userData {
                let userObject = try? jsonDecoder.decode(ELUser.self, from: data)
                return userObject
            }
            return nil
        }
    }
        static func saveCurrentUser(user: ELUser) {
        currentUser = user
        let userData = try? jsonEncoder.encode(user)
        userDefaults.set(userData, forKey: StorageKeys.user.rawValue)
    }
    
    static func clearUserData() {
        currentUser = nil
        userDefaults.removeObject(forKey: StorageKeys.user.rawValue)
    }
}
