//
//  CategoryItem.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 20/1/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import Foundation


struct CategoryItem {
    let title: String?
    let imageUrl: String?
    let id: String?
    
    init(from dictionary: [String : Any], id: String) {
        title = dictionary["name"] as? String
        imageUrl = dictionary["pic_url"] as? String
        self.id = id
    }
}
