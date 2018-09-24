//
//  NotificationsController.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 23/9/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit
import SVProgressHUD

class NotificationsController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var notifications: [NotificationItem] = [] {
        didSet {
            self.notifications = notifications.sorted(by: { (first, second) -> Bool in
                first.timestamp > second.timestamp
            })
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchNotifications()
        title = "Notifications"
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(NotificationCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func fetchNotifications() {
        SVProgressHUD.showLoader()
        FireStoreManager.getNotifications { [weak self] (notifications, error) in
            SVProgressHUD.dismissLoader()
            if let notifications = notifications {
                self?.notifications = notifications
            } else {
                UIAlertController.showErrorAlert()
            }
        }
    }

}

extension NotificationsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as NotificationCell
        cell.setCellWithNotification(notifications[indexPath.row])
        return cell
    }
    
}
