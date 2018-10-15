//
//  UserController.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 23/9/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit

class UserController: UIViewController {
    enum TableCells: Int {
        case editProfile = 0
        case notifications = 1
        case orders
    }

    @IBOutlet weak var tableView: UITableView!
    let tableCells = ["Edit Profile", "Notifications", "My Orders"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()    
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func showNotifications() {
        let noticationsController = NotificationsController.controllerInStoryboard(.user)
        navigationController?.pushViewController(noticationsController, animated: true)
    }
    
    func showOrders() {
        let ordersController = MyOrdersController.controllerInStoryboard(.user)
        navigationController?.pushViewController(ordersController, animated: true)
    }
    
    func showEditProfileView() {
        let editProfileView = SignupController.controllerInStoryboard(.auth)
        editProfileView.isEditingProfile = true
        navigationController?.pushViewController(editProfileView, animated: true)
    }
}

extension UserController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = tableCells[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case TableCells.notifications.rawValue:
            showNotifications()
        case TableCells.orders.rawValue:
            showOrders()
        case TableCells.editProfile.rawValue:
            showEditProfileView()
        default:
            break
        }
    }
    
}
