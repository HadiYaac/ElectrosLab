//
//  BasketController.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 20/1/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit

protocol BasketView: BaseView {
}

class BasketController: UIViewController, BasketView {
    @IBOutlet weak var tableView: UITableView!
    var tableValues = [Item]()
    @IBOutlet weak var checkOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        updateTableView()
        title = "Basket"
        checkOutButton.backgroundColor = UIColor.electrosLabBlue()
        addDeleteBarButton()
    }
    
    func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 85
        tableView.tableFooterView = UIView()
        tableView.register(BasketCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func addDeleteBarButton() {
        let deleteBtn = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearBasket))
        navigationItem.rightBarButtonItem = deleteBtn
    }
    
    @objc func clearBasket() {
        if self.tableValues.count == 0 {
            return
        }
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to delete all items from the basket?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Clear Basket", style: .destructive) { (action) in
            ELUserDefaultsManager.clearBasket()
            self.updateTableView()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updateTableView() {
        if let basket = ELUserDefaultsManager.getBasketArray() {
            tableValues = basket
            tableView.reloadData()
        }
    }
    @IBAction func proceedToCheckout(_ sender: UIButton) {
        if self.tableValues.count > 0 {
            let checkoutController = CheckoutController.controllerInStoryboard(.basket)
            navigationController?.pushViewController(checkoutController, animated: true)
        } else {
            UIAlertController.showAlert(with: "", message: "Your basket is empty. Add some items to proceed")
        }

    }
}

extension BasketController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as BasketCell
        let item = self.tableValues[indexPath.row]
        cell.item = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ELUserDefaultsManager.removeItemFromBasket(item: self.tableValues[indexPath.row])
            self.updateTableView()
        }
    }
    
}
