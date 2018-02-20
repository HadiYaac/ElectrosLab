//
//  TabbarController.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 7/1/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit
import RxSwift

protocol TabbarView: BaseView {
    var didPressBasket: ((UINavigationController) -> Void)? { get set }
}

class TabbarController: UITabBarController, UITabBarControllerDelegate, TabbarView {
    var didPressBasket: ((UINavigationController) -> Void)?
    var emptyWishListBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(emptyWishList))
    var basketBarButton: UIBarButtonItem?
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbarItems()
        setupNavigationItem()
        title = "ElectroSLab"
        self.delegate = self
        emptyWishListBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(emptyWishList))
        self.selectedIndex = 1

        ELUserDefaultsManager.subject.subscribe(onNext: { (count) in
            printD("updated count: \(count)")
            if count > 0 {
                self.basketBarButton?.addBadge(number: count)
            } else {
                self.basketBarButton?.removeBadge()
            }
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let count = ELUserDefaultsManager.getBasketArray()?.count {
            printD("initial count: \(count)")
            if count > 0 {
                basketBarButton?.addBadge(number: count)
            }
        }
    }
    
    @objc func emptyWishList() {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to delete all items from your wishlist?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Clear Wishlist", style: .destructive) { (action) in
            ELUserDefaultsManager.clearWishlist()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadWishlist"), object: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setupNavigationItem() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        }
        navigationController?.navigationBar.barTintColor = UIColor.electrosLabBlue()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        basketBarButton = UIBarButtonItem(title: "Basket", style: .plain, target: self, action: #selector(basketPressed))
        basketBarButton?.image = #imageLiteral(resourceName: "basket")
        basketBarButton?.title = nil
        
        self.navigationItem.rightBarButtonItem = basketBarButton
    }
    
    @objc func basketPressed() {
        if StorageManager.getCurrentUser() == nil {
            UIAlertController.showAlert(with: "", message: "Please login/signup to proceed")
        } else {
            self.didPressBasket?(navigationController!)
        }
    }
    
    func setupTabbarItems() {
        let categories = tabBar.items![0]
        let news = tabBar.items![1]
        let wishList = tabBar.items![2]
        let settings = tabBar.items![3]
        
        categories.title = "Categories"
        categories.image = #imageLiteral(resourceName: "list")
        news.title = "News"
        news.image = #imageLiteral(resourceName: "news")
        wishList.title = "Wishlist"
        wishList.image = #imageLiteral(resourceName: "star")
        settings.title = "Settings"
        settings.image = #imageLiteral(resourceName: "settingsGear")
        tabBar.tintColor = UIColor.electrosLabBlue()
    }


}

extension TabbarController {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController.isKind(of: WishlistController.self) {
            if (navigationItem.rightBarButtonItems?.count)! > 1 {
                navigationItem.rightBarButtonItems?.remove(at: 1)
            }
            navigationItem.rightBarButtonItems?.append(emptyWishListBarButton)
        } else {
            if (navigationItem.rightBarButtonItems?.count)! > 1 {
                navigationItem.rightBarButtonItems?.remove(at: 1)
            }
        }
    }
}
