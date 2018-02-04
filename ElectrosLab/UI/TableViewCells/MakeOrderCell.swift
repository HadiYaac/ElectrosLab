//
//  MakeOrderCell.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 4/2/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit

class MakeOrderCell: UITableViewCell {

    @IBOutlet weak var orderButton: UIButton!
    var didPressOrderButton: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        orderButton.backgroundColor = UIColor.electrosLabBlue()
        orderButton.setTitle("Order", for: .normal)
        orderButton.setTitleColor(UIColor.white, for: .normal)
        orderButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        selectionStyle = .none
    }

    @IBAction func orderPressed(_ sender: Any) {
        self.didPressOrderButton?()
    }
    
    
}
