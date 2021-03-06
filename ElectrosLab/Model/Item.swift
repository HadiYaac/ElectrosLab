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
    let itemId: String
    
    init(from dictionary: [String : Any], id: String) {
        name = dictionary[APIKeys.name.rawValue] as? String
        categoryId = dictionary[APIKeys.category_id.rawValue] as? String
        picUrl = dictionary[APIKeys.pic_url.rawValue] as? String
        price = dictionary[APIKeys.price.rawValue] as? Float
        self.id = id
        self.itemId = dictionary[APIKeys.id.rawValue] as! String
    }
    
    init(from dictionary: [String: Any]) {
        name = dictionary["name"] as? String
        categoryId = dictionary["category_id"] as? String
        picUrl = dictionary["pic_url"] as? String
        price = dictionary["price"] as? Float
        quantity = dictionary["count"] as! Int
        self.itemId = dictionary["id"] as! String
        self.id = dictionary["item_id"] as? String
    }
    
    func itemDictionary() -> [String : Any] {
        var itemDictionary = [String: Any]()
        itemDictionary[APIKeys.item_id.rawValue] = self.id
        itemDictionary[APIKeys.id.rawValue] = self.itemId
        itemDictionary[APIKeys.count.rawValue] = self.quantity
        itemDictionary[APIKeys.name.rawValue] = self.name
        itemDictionary[APIKeys.pic_url.rawValue] = self.picUrl
        itemDictionary[APIKeys.price.rawValue] = self.price
        itemDictionary[APIKeys.category_id.rawValue] = self.categoryId
        return itemDictionary
    }
}


enum APIKeys: String {
    case item_id
    case count
    case name
    case pic_url
    case price
    case category_id
    case phone_number
    case email
    case city
    case street
    case building
    case floor
    case user_id
    case title
    case body
    case timestamp
    case id
}

