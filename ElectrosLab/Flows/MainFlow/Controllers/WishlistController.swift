//
//  WishlistController.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 14/1/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit

protocol WishlistView: BaseView {
    
}

class WishlistController: UIViewController, WishlistView {
    var emptyWishlistButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(emptyWishlist))

    @IBOutlet weak var tableView: UITableView!
    var tableValues = [Item]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        updateTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: Notification.Name(rawValue: "reloadWishlist"), object: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        updateTableView()
        navigationItem.rightBarButtonItems?.append(emptyWishlistButton)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationItem.rightBarButtonItems?.remove(at: 1)
    }
    
    @objc func emptyWishlist() {
        printD("empty wishlist")
    }
    
    @objc func updateTableView() {
        if let wishlist = ELUserDefaultsManager.getWishlistArray() {
            self.tableValues = wishlist
            self.tableView.reloadData()
        }
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.register(WishlistCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func showItemDetails(item: Item) {
        let itemDetailController = ItemDetailsController.controllerInStoryboard(.store)
        itemDetailController.selectedItem = item
        itemDetailController.isWithList = true
        navigationController?.pushViewController(itemDetailController, animated: true)
    }
}

extension WishlistController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as WishlistCell
        let item = tableValues[indexPath.row]
        cell.setCell(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ELUserDefaultsManager.removeItemFromWishlist(item: self.tableValues[indexPath.row])
            self.updateTableView()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.tableValues[indexPath.row]
        if StorageManager.getCurrentUser() == nil {
            UIAlertController.showLoginAlert()
           // UIAlertController.showAlert(with: "", message: "Please login/signup to proceed")
        } else {
            self.showItemDetails(item: item)
        }
    }
}
