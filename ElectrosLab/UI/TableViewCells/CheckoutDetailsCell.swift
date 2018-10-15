//
//  CheckoutDetailsCell.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 4/2/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit

class CheckoutDetailsCell: UITableViewCell {

    @IBOutlet weak var userAddressLabel: UILabel!
    @IBOutlet weak var userPhoneNumberLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var userfullnameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func fillCellWithInfo(total: Float) {
        if let user = StorageManager.getCurrentUser() {
            userfullnameLabel.text = "Name: " + user.name!
            userPhoneNumberLabel.text = user.phoneNumber
            if let city = user.city, let street = user.street, let building = user.building, let floor = user.floor {
                userAddressLabel.text = "Address: " + city + ", " + street + ", " + building + ", " + floor
            }
        }
        totalLabel.text = "Total: $\(total)"
    }

    
}
