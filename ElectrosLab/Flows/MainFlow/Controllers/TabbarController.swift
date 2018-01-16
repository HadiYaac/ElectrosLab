//
//  TabbarController.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 7/1/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit

protocol TabbarView: BaseView {
    
}

class TabbarController: UITabBarController, UITabBarControllerDelegate, TabbarView {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbarItems()
        setupNavigationItem()
        title = "ElectroSLab"
    }
    
    func setupNavigationItem() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        }
        navigationController?.navigationBar.barTintColor = UIColor.electrosLabBlue()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        let basketBarButton = UIBarButtonItem(title: "Basket", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = basketBarButton
    }
    
    func setupTabbarItems() {
        let categories = tabBar.items![0]
        let news = tabBar.items![1]
        let wishList = tabBar.items![2]
        let settings = tabBar.items![3]
        
        categories.title = "Categories"
        news.title = "News"
        wishList.title = "Wishlist"
        settings.title = "Settings"
    }


}
