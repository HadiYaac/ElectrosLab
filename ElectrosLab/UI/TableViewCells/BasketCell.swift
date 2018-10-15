//
//  BasketCell.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 2/2/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit
import Kingfisher

class BasketCell: UITableViewCell {

    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var itemDetailsLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    var item: Item? {
        didSet {
            setCellWithItem(item: item!)
            stepper.value = Double(item!.quantity)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        stepper.tintColor = UIColor.electrosLabBlue()
        stepper.minimumValue = 1
        selectionStyle = .none
    }
    
    func setCellWithItem(item: Item) {
        if let imageUrl = item.picUrl {
            let url = URL(string: imageUrl)
            let resource = ImageResource(downloadURL: url!)
            itemImageView.kf.indicatorType = .activity
            itemImageView.kf.setImage(with: resource)
        } else {
            itemImageView.image = #imageLiteral(resourceName: "Raspberry-Pi-2-Bare-FL.jpg")
        }
        
        if let name = item.name {
            itemDetailsLabel.text = name
        }
        quantityLabel.text = "\(item.quantity)"
        updateTotalLabel()
    }
    
    private func updateTotalLabel() {
        if let price = self.item?.price {
            let totalPrice = price * Float(item!.quantity)
            var totalPriceString = "\(totalPrice)"
            totalPriceString.addDollarSign()
            totalLabel.text = totalPriceString
        }
    }
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        self.item?.quantity = Int(stepper.value)
        quantityLabel.text = "\(Int(stepper.value))"
        ELUserDefaultsManager.updateItemCount(item: self.item!, quantity: Int(stepper.value))
        updateTotalLabel()
    }
    
    
}


