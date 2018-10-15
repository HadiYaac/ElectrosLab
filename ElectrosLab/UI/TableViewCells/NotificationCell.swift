//
//  NotificationCell.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 23/9/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    private func setupCell() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.numberOfLines = 0
        bodyLabel.numberOfLines = 0
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
        dateLabel.textColor = UIColor.gray
    }
    
    func setCellWithNotification(_ notification: NotificationItem) {
        titleLabel.text = notification.title
        bodyLabel.text = notification.body
        dateLabel.text = getDateFromTimestamp(notification.timestamp)
    }
    
    private func getDateFromTimestamp(_ timeStamp: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        return dateFormatter.string(from: date)
    }

    
}
