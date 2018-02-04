//
//  CategoriesCell.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 7/1/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit
import Kingfisher

class CategoriesCell: UITableViewCell {

    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
        selectionStyle = .none
    }
    
    func setCell(image: UIImage?, title: String) {
        if let image = image {
            categoryImageView.image = image
        }
        categoryTitleLabel.text = title
    }
    
    
    func setCellWithCategoryItem(category: CategoryItem) {
        if let title = category.title {
            categoryTitleLabel.text = title
        }
        if let imageURL = category.imageUrl {
            let resource = ImageResource(downloadURL: URL(string: imageURL)!)
            categoryImageView.kf.indicatorType = .activity
            categoryImageView.kf.setImage(with: resource)
        } else {
            categoryImageView.image = #imageLiteral(resourceName: "Raspberry-Pi-2-Bare-FL.jpg")
        }
    }

    
}
