//
//  CheckoutController.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 4/2/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit
import SVProgressHUD

class CheckoutController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tableValues = ELUserDefaultsManager.getBasketArray()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        title = "Checkout"
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(CheckoutItemCell.self)
        tableView.register(CheckoutDetailsCell.self)
        tableView.register(MakeOrderCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getTotalPrice() -> Float {
        var totalPrice: Float = 0.0
        tableValues.forEach { (item) in
            let quantity = item.quantity
            let price = item.price!
            let total = Float(quantity) * price
            totalPrice = totalPrice + total
        }
        
        return totalPrice
    }
    
    func makeOrderRequest() {
        printD("made order")
        SVProgressHUD.showLoader()
        FireStoreManager.uploadNewOrder(orderItems: self.tableValues) { (error, success) in
            SVProgressHUD.dismiss()
            if let error = error {
                UIAlertController.showAlert(with: "", message: error.localizedDescription)
            } else {
                ELUserDefaultsManager.clearBasket()
                self.navigationController?.popToRootViewController(animated: true)
                UIAlertController.showAlert(with: "Success", message: "Your order has been requested. Thank you")
            }
        }
    }
}

extension CheckoutController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableValues.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0..<tableValues.count:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CheckoutItemCell
            let item = self.tableValues[indexPath.row]
            cell.setCell(item: item)
            return cell
        case tableValues.count:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CheckoutDetailsCell
            cell.fillCellWithInfo(total: getTotalPrice())
            return cell
        case tableValues.count + 1:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as MakeOrderCell
            cell.didPressOrderButton = { [weak self] in
                self?.makeOrderRequest()
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
