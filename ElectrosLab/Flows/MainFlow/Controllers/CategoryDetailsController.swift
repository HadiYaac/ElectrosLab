//
//  CategoryDetailsController.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 1/2/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit

class CategoryDetailsController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var category: CategoryItem?
    var tableValues = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let category = category, let title = category.title {
            self.title = title
        }
        setupTableView()
        if let categoryId = category?.id {
            fetchItems(categoryId: categoryId)
        }
    }
    
    func setupTableView() {
        tableView.register(ItemCell.self)
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func fetchItems(categoryId: String) {
        FireStoreManager.getItemsForCategory(categoryId: categoryId) { (error, items) in
            if error != nil {
                UIAlertController.showErrorAlert()
            } else {
                self.tableValues = items!
                self.tableView.reloadData()
            }
        }
    }
    
    func proceedToItemDetails(item: Item) {
        let itemDetailsController = ItemDetailsController.controllerInStoryboard(.store)
        itemDetailsController.selectedItem = item
        navigationController?.pushViewController(itemDetailsController, animated: true)
    }

}

extension CategoryDetailsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ItemCell
        let item = self.tableValues[indexPath.row]
        cell.setCell(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.tableValues[indexPath.row]
        proceedToItemDetails(item: item)
    }
}

extension String {
    mutating func addDollarSign() {
        self = "$" + self
    }
}

