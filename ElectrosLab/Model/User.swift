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
    
    init(from dictionary: [String : Any], userId: String) {
        id = userId
        name = dictionary["name"] as? String
        phoneNumber = dictionary["phone_number"] as? String
        email = dictionary["email"] as? String
        city = dictionary["city"] as? String
        street = dictionary["street"] as? String
        building = dictionary["building"] as? String
        floor = dictionary["floor"] as? String
    }
    
    
    
    
}
