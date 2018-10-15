//
//  Order.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 23/9/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import Foundation

class Order {
    let createdAt: Int?
    let items: [Item]?
    let total: String?
    let orderId: String?
    var user: ELUser?
    init(from dictionary: [String : Any], id: String) {
        orderId = id
        let timestamp = dictionary["created_at"] as? String
        if let timestamp = timestamp {
            createdAt = Int(Double(timestamp)!)
        } else {
            createdAt = nil
        }
        total = dictionary["total"] as? String
        user = ELUser(from: dictionary["user"] as! [String: Any])
        let itemsArray = dictionary["items"] as? [[String : Any]]
        var tempItems = [Item]()
        itemsArray?.forEach({ (dictionary) in
            let item = Item(from: dictionary)
            tempItems.append(item)
        })
        self.items = tempItems
    }
}
