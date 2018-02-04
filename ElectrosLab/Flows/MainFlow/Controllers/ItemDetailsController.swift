//
//  ItemDetailsController.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 2/2/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit
import Kingfisher

class ItemDetailsController: UIViewController {

    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    var selectedItem: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = selectedItem {
            fillViewFromItem(item: item)
        }
        setupButtons()
        title = "Item Details"
    }
    
    func fillViewFromItem(item: Item) {
        if let detailsText = item.name {
            itemDescriptionLabel.text = detailsText
        }
        if let picUrl = item.picUrl {
            let url = URL(string: picUrl)
            let resource = ImageResource(downloadURL: url!)
            itemImageView.kf.indicatorType = .activity
            itemImageView.kf.setImage(with: resource)
        } else {
            itemImageView.image = #imageLiteral(resourceName: "Raspberry-Pi-2-Bare-FL.jpg")
        }
    }
    
    func setupButtons() {
        leftButton.setTitle("Add to basket", for: .normal)
        rightButton.setTitle("Add to wishlist", for: .normal)
        leftButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.setTitleColor(UIColor.white, for: .normal)
        leftButton.backgroundColor = UIColor.electrosLabBlue()
        rightButton.backgroundColor = UIColor.electrosLabBlue()
        rightButton.cornerRadius = 5
        leftButton.cornerRadius = 5

    }
    /// Add item to basket
    @IBAction func leftButtonAction(_ sender: UIButton) {
        ELUserDefaultsManager.addItemToBasket(item: selectedItem!)
    }
    /// Add item to wishlist
    @IBAction func rightButtonAction(_ sender: UIButton) {
    
    }
    
    

}
