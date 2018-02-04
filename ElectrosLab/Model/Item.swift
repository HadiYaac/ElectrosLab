//
//  Item.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 1/2/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import Foundation


struct Item: Codable {
    let name: String?
    let categoryId: String?
    let picUrl: String?
    let price: Float?
    let id: String?
    var quantity: Int = 1
    
    init(from dictionary: [String : Any], id: String) {
        name = dictionary["name"] as? String
        categoryId = dictionary["category_id"] as? String
        picUrl = dictionary["pic_url"] as? String
        price = dictionary["price"] as? Float
        self.id = id
    }
}


