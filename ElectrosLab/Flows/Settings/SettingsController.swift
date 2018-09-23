//
//  SettingsController.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 14/1/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit
import SafariServices

protocol SettingsView: BaseView {
}

class SettingsController: UIViewController, SettingsView {
    

    var tableValues = [String]()
    private let whatsAppURL = URL(string: "https://api.whatsapp.com/send?phone=96181679391")
    private let websiteURL = URL(string: "http://www.electroslab.com")
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if StorageManager.getCurrentUser() != nil {
            tableValues = ["About Us", "Find our store", "Contact Us", "Logout"]
        } else {
            tableValues = ["About Us", "Find our store", "Contact Us", "Sign In/Sign Up"]
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
    
    func showMapView() {
        let locationController = LocationController.controllerInStoryboard(.settings)
        navigationController?.pushViewController(locationController, animated: true)
    }
    
    func showContactUsActionSheet() {
        let actionSheet = UIAlertController(title: "Contact Us", message: "You can contact us using one of the following methods", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        let callAction = UIAlertAction(title: "Call Us", style: .default) { [weak self] (action) in
            self?.callUs()
        }
        actionSheet.addAction(callAction)
        
        let whatsAppAction = UIAlertAction(title: "WhatsApp", style: .default) { [weak self] (action) in
            self?.openWhatsApp()
        }
        if appCanOpenWhatsApp() {
            actionSheet.addAction(whatsAppAction)
        }
        
        let websiteAction = UIAlertAction(title: "Visit our Website", style: .default) { [weak self] (action) in
            self?.openWebsite()
        }
        actionSheet.addAction(websiteAction)
        
        let facebookAction = UIAlertAction(title: "Facebook", style: .default) { [weak self] (action) in
            self?.openFacebook()
        }
        actionSheet.addAction(facebookAction)
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func callUs() {
        guard let number = URL(string: "tel://" + "0096181679391") else { return }
        UIApplication.shared.open(number)
    }
    
    private func openWhatsApp() {
        UIApplication.shared.open(whatsAppURL!, options: [:], completionHandler: nil)
    }
    
    private func openWebsite() {
        let safariController = SFSafariViewController(url: websiteURL!)
        present(safariController, animated: true, completion: nil)
    }
    
    private func openFacebook() {
        UIApplication.tryURL(urls: ["fb://profile?id=ElectrosLab", // App
            "http://www.facebook.com/ElectrosLab"] )
    }
    
    private func appCanOpenWhatsApp() -> Bool {
        return UIApplication.shared.canOpenURL(whatsAppURL!)
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
        
        if tableValues[indexPath.row] == "Find our store" {
            showMapView()
        }
        if tableValues[indexPath.row] == "Contact Us" {
            showContactUsActionSheet()
        }
    }
}

extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(URL(string: url)!) {
                application.openURL(URL(string: url)!)
                return
            }
        }
    }
}
