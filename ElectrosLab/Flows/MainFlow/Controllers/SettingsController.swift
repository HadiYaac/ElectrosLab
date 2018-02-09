//
//  SettingsController.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 14/1/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit

protocol SettingsView: BaseView {
}

class SettingsController: UIViewController, SettingsView {
    

    var tableValues = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if StorageManager.getCurrentUser() != nil {
            tableValues = ["Edit Profile", "About Us", /*"Find our store",*/ "Logout"]
        } else {
            tableValues = ["About Us", /*"Find our store",*/ "Sign In/Sign Up"]
        }
        setupTableView()
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.register(SettingsCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func logoutAction() {
        UIAlertController.showAlert(with: nil, message: "Are you sure you want to logout?", okayButtonTitle: "Yes", okayButtonCallback: {
            StorageManager.clearUserData()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logout"), object: nil)
        }, cancelButtonTitle: "Cancel", cancelButtonCallBack: nil)
        
    }
    
    func showAboutUs() {
        let aboutUsController = AboutUsController.controllerInStoryboard(.settings)
        navigationController?.pushViewController(aboutUsController, animated: true)
    }
    
    func showEditProfileView() {
        let editProfileView = SignupController.controllerInStoryboard(.auth)
        editProfileView.isEditingProfile = true
        navigationController?.pushViewController(editProfileView, animated: true)
    }
}

extension SettingsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SettingsCell
        cell.setCellTitle(title: tableValues[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableValues[indexPath.row] == "Logout" {
            self.logoutAction()
        }
        if tableValues[indexPath.row] == "Sign In/Sign Up" {
            StorageManager.clearUserData()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logout"), object: nil)
        }
        
        if tableValues[indexPath.row] == "About Us" {
            self.showAboutUs()
        }
        
        if tableValues[indexPath.row] == "Edit Profile" {
            self.showEditProfileView()
        }
    }
}
