//
//  WishlistCell.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 8/2/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit
import Kingfisher

class WishlistCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
    }
    
    func setCell(item: Item) {
        if let name = item.name {
            itemNameLabel.text = name
        }
        if let picURL = item.picUrl {
            let url = URL(string: picURL)
            let resource = ImageResource(downloadURL: url!)
            itemImageView.kf.indicatorType = .activity
            itemImageView.kf.setImage(with: resource)
        }
    }
    
}
