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
    
    func showConfirmationPopup(){
        UIAlertController.showAlert(with: "Confirmation", message: "Total price: $\(getTotalPrice()) + $5 Delivery Cost. \nAre you sure you want to proceed?", okayButtonTitle: "Yes", okayButtonCallback: {
            self.makeOrderRequest()
        }, cancelButtonTitle: "No, thanks", cancelButtonCallBack: nil)
    }
    
    func makeOrderRequest() {
        printD("made order")
        SVProgressHUD.showLoader()
        FireStoreManager.uploadNewOrder(orderItems: self.tableValues) { [weak self] (error, success) in
            SVProgressHUD.dismiss()
            if let error = error {
                UIAlertController.showAlert(with: "", message: error.localizedDescription)
            } else {
                ELUserDefaultsManager.clearBasket()
                self?.navigationController?.popToRootViewController(animated: true)
                UIAlertController.showAlert(with: "Thank you!", message: "Your order has been requested. It may take up to 3 working days to be delivered. \nGood luck :)")
                self?.sendNotificationToAdmin()
            }
        }
    }
    
    private func sendNotificationToAdmin() {

            let url = URL(string: "https://fcm.googleapis.com/fcm/send")
            var request = URLRequest(url: url!)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("key=AAAA9vUSgaw:APA91bHTxtP-3OQ5FMAA17nqz8f1Xj4gR8ekEgYQ6ezFTo2yOMigYd11GT7MVtZsHrX5B8aon5O78dkfPsNPXeNIMtrtwtfLqQbnQ0Ynro7j500ggvCZDSi5tldQX06bjmt9s7XQY8Dy", forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            let bodyString = """
            {
            "to":"/topics/admin",
            "notification": {
            "title" : "New Order",
            "body" : "A new order was submitted by \(StorageManager.getCurrentUser()!.name!)",
            "sound" : "default",
            "badge" : "1"
            }
            }
            """
            request.httpBody = bodyString.data(using: .utf8)
            SVProgressHUD.showLoader()
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                SVProgressHUD.dismiss()
            }
            task.resume()
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
                self?.showConfirmationPopup()
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
