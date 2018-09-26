//
//  ItemDetailsController.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 2/2/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD
import SKPhotoBrowser

class ItemDetailsController: UIViewController {

    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemIdLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    var isWithList: Bool = false
    
    var selectedItem: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = selectedItem {
            fillViewFromItem(item: item)
        }
        setupButtons()
        title = "Item Details"
        if isWithList {
            stackView.removeArrangedSubview(rightButton)
            rightButton.removeFromSuperview()
        }
        addTapGestureToImageView()
        registerFor3DTouch()
    }
    
    private func registerFor3DTouch() {
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: self.view)
        }
    }
    
    
    private func addTapGestureToImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showImages))
        itemImageView.isUserInteractionEnabled = true
        tapGesture.numberOfTapsRequired = 1
        itemImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func showImages() {
        guard let image = itemImageView.image else { return }
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImage(image)
        images.append(photo)
        let browser = SKPhotoBrowser(photos: [photo], initialPageIndex: 0)
        SKPhotoBrowserOptions.bounceAnimation = true

        present(browser, animated: true, completion: nil)
        
    }

    func fillViewFromItem(item: Item) {
        if let detailsText = item.name, let price = item.price {
            itemDescriptionLabel.text = detailsText
            priceLabel.text = "$\(price)"
        }
        if let picUrl = item.picUrl {
            let url = URL(string: picUrl)
            let resource = ImageResource(downloadURL: url!)
            itemImageView.kf.indicatorType = .activity
            itemImageView.kf.setImage(with: resource)
        } else {
            itemImageView.image = #imageLiteral(resourceName: "Raspberry-Pi-2-Bare-FL.jpg")
        }
        itemIdLabel.text = "ID: " + item.itemId
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
        SVProgressHUD.showSuccessStatus(status: "Item added to basket")
        navigationController?.popViewController(animated: true)
    }
    /// Add item to wishlist
    @IBAction func rightButtonAction(_ sender: UIButton) {
        ELUserDefaultsManager.addItemToWishlist(item: selectedItem!)
        SVProgressHUD.showSuccessStatus(status: "Item added to wishlist")
        navigationController?.popViewController(animated: true)
    }
}

extension ItemDetailsController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let convertedPoint = view.convert(location, to: itemImageView)
        if itemImageView.bounds.contains(convertedPoint) {
            guard let image = itemImageView.image else { return nil }
            var images = [SKPhoto]()
            let photo = SKPhoto.photoWithImage(image)
            images.append(photo)
            let browser = SKPhotoBrowser(photos: [photo], initialPageIndex: 0)
            SKPhotoBrowserOptions.bounceAnimation = true
            return browser
        } else {
            return nil
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        present(viewControllerToCommit, animated: true, completion: nil)
    }
    
    
}
