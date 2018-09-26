//
//  ItemCell.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 1/2/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit
import Kingfisher

class ItemCell: UITableViewCell {

    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemDetailsLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCell(with item: Item, showQuanitity: Bool = false) {
        itemImageView.image = #imageLiteral(resourceName: "Raspberry-Pi-2-Bare-FL.jpg")
        if let name = item.name {
            itemDetailsLabel.text = name
        }
        if let price = item.price {
            var priceString = "\(price)"
            priceString.addDollarSign()
            itemPriceLabel.text = priceString
        }
        
        if showQuanitity, let price = item.price {
            var priceString = "\(price)"
            priceString.addDollarSign()
            priceString = priceString + ", (ID: \(item.itemId), Qty: \(item.quantity))"
            itemPriceLabel.text = priceString
        }
        
        if let imageUrl = item.picUrl {
            let url = URL(string: imageUrl)
            let resource = ImageResource(downloadURL: url!)
            itemImageView.kf.indicatorType = .activity
            itemImageView.kf.setImage(with: resource)
        } else {
            itemImageView.image = #imageLiteral(resourceName: "Raspberry-Pi-2-Bare-FL.jpg")
        }

    }

    
}
