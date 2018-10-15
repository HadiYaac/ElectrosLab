//
//  NotificationItem.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 14/8/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import Foundation

struct NotificationItem {
    let title: String
    let body: String
    let timestamp: Int
    let messageId: String
    let id: String
    
    init(from dictionary: [String : Any], id: String) {
        title = dictionary[APIKeys.title.rawValue] as! String
        body = dictionary[APIKeys.body.rawValue] as! String
        timestamp = dictionary[APIKeys.timestamp.rawValue] as! Int
        messageId = dictionary[APIKeys.id.rawValue] as! String
        self.id = id
    }
}
