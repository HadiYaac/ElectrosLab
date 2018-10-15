//
//  NewsItem.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 20/1/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import Foundation


struct NewsItem {
    let title: String?
    let message: String?
    
    init(from dictionary: [String : Any]) {
        title = dictionary["title"] as? String
        message = dictionary["description"] as? String
    }
}
