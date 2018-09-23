//
//  User.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 6/2/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import Foundation

struct ELUser: Codable {
    var id: String?
    var name: String?
    var phoneNumber: String?
    var email: String?
    var city: String?
    var street: String?
    var building: String?
    var floor: String?
    
    init(from dictionary: [String : Any]) {
        id = dictionary["user_id"] as? String
        name = dictionary["name"] as? String
        phoneNumber = dictionary["phone_number"] as? String
        email = dictionary["email"] as? String
        city = dictionary["city"] as? String
        street = dictionary["street"] as? String
        building = dictionary["building"] as? String
        floor = dictionary["floor"] as? String
    }
    
    init(from dictionary: [String : Any], userId: String) {
        id = userId
        name = dictionary[APIKeys.name.rawValue] as? String
        phoneNumber = dictionary[APIKeys.phone_number.rawValue] as? String
        email = dictionary[APIKeys.email.rawValue] as? String
        city = dictionary[APIKeys.city.rawValue] as? String
        street = dictionary[APIKeys.street.rawValue] as? String
        building = dictionary[APIKeys.building.rawValue] as? String
        floor = dictionary[APIKeys.floor.rawValue] as? String
    }
    
    func getUserDictionary() -> [String : Any] {
        var dictionary = [String : Any]()
        dictionary[APIKeys.user_id.rawValue] = self.id
        dictionary[APIKeys.name.rawValue] = self.name
        dictionary[APIKeys.phone_number.rawValue] = self.phoneNumber
        dictionary[APIKeys.email.rawValue] = self.email
        dictionary[APIKeys.city.rawValue] = self.city
        dictionary[APIKeys.street.rawValue] = self.street
        dictionary[APIKeys.building.rawValue] = self.building
        dictionary[APIKeys.floor.rawValue] = self.floor
        
        return dictionary
    }
}

