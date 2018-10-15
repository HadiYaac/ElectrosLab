//
//  CheckoutItemCell.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 4/2/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit
import Kingfisher

class CheckoutItemCell: UITableViewCell {

    @IBOutlet weak var itemTotalPriceCell: UILabel!
    @IBOutlet weak var itemCountCell: UILabel!
    @IBOutlet weak var itemDetailsLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setCell(item: Item) {
        if let name = item.name {
            itemDetailsLabel.text = name
        }
        itemCountCell.text = "Count: \(item.quantity)"
        if let picURL = item.picUrl {
            let url = URL(string: picURL)
            let resource = ImageResource(downloadURL: url!)
            itemImageView.kf.indicatorType = .activity
            itemImageView.kf.setImage(with: resource)
        } else {
            itemImageView.image = #imageLiteral(resourceName: "Raspberry-Pi-2-Bare-FL.jpg")
        }
        updateTotalLabel(item: item)
    }
    
    private func updateTotalLabel(item: Item) {
        let quantity = Float(item.quantity)
        let price = item.price!
        let total = quantity * price
        var totalString = "\(total)"
        totalString.addDollarSign()
        itemTotalPriceCell.text = "Total: " + totalString
    }


    
}
