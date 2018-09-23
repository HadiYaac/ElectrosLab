//
//  OrderCell.swift
//  ElectroSLabAdmin
//
//  Created by Hussein Jaber on 18/2/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var didPressButton: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCell(order: Order) {
        if let createdAt = order.createdAt {
            let date = Date(timeIntervalSince1970: TimeInterval(createdAt))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: date)
            dateLabel.text = "Date: " + dateString
        } else {
            dateLabel.text = "Date: N/A"
        }
        updateTotalLabel(total: order.total)
    }
    
    private func updateTotalLabel(total: String?) {
        if let total = total {
            totalLabel.text = "Total: " + total
        } else {
            totalLabel.text = "Total: -"
        }
    }
    



}


