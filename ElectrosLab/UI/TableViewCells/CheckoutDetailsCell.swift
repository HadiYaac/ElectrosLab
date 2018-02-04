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
        totalLabel.text = "Total: $\(total)"
    }

    
}
