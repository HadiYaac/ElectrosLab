//
//  MyOrdersController.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 23/9/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit
import SVProgressHUD

class MyOrdersController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var orders: [Order] = [] {
        didSet {
            self.orders = self.orders.sorted(by: { (first, second) -> Bool in
                first.createdAt! > second.createdAt!
            })
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        title = "My Orders"
        getOrders()
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(OrderCell.self)
        tableView.register(ItemCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func getOrders() {
        SVProgressHUD.showLoader()
        FireStoreManager.fetchUserOrders { [weak self] (orders, error) in
            SVProgressHUD.dismissLoader()
            if error != nil {
                UIAlertController.showErrorAlert()
            } else {
                if let orders = orders {
                    self?.orders = orders
                }
            }
        }
    }

}

extension MyOrdersController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 1
        if let itemsCount = orders[section].items?.count {
            count = count + itemsCount
        }
        return count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let order = orders[indexPath.section]
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as OrderCell
            cell.setCell(order: order)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ItemCell
            cell.setCell(with: order.items![indexPath.row - 1], showQuanitity: true)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let orderNumber = "\(section + 1)"
        return "Order #\(orderNumber)"
    }
}
