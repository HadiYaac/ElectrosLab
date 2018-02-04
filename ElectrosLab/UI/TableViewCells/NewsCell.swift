//
//  NewsCell.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 14/1/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        titleLabel.numberOfLines = 0
        detailsLabel.numberOfLines = 0
    }
    
    func setupCell(with newsItem: NewsItem) {
        if let title = newsItem.title {
            titleLabel.text = title
        }
        if let message = newsItem.message {
            detailsLabel.text = message
        }
    }
    
}
