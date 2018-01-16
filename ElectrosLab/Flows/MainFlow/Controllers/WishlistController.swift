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

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.register(CategoriesCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension WishlistController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CategoriesCell
        cell.setCell(image: #imageLiteral(resourceName: "Raspberry-Pi-2-Bare-FL.jpg"), title: "Wishlist Item \(indexPath.row)")
        return cell
    }
}
