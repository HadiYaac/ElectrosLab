//
//  CategoryDetailsController.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 1/2/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit
import SVProgressHUD

class CategoryDetailsController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var category: CategoryItem?
    var tableValues = [Item]()
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearching: Bool = false
    var searchResults = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let category = category, let title = category.title {
            self.title = title
        }
        setupTableView()
        if let categoryId = category?.id {
            fetchItems(categoryId: categoryId)
        }
        addSearchBar()
    }
    
    func setupTableView() {
        tableView.register(ItemCell.self)
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func addSearchBar() {
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor.electrosLabBlue()
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.searchController = searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
            //navigationItem.title = "Categories"
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
            navigationController?.navigationBar.barTintColor = UIColor.electrosLabBlue()
            self.searchController.dimsBackgroundDuringPresentation = false
            self.searchController.hidesNavigationBarDuringPresentation = false
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search products", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        } else {
            self.searchController.dimsBackgroundDuringPresentation = false
            self.searchController.hidesNavigationBarDuringPresentation = false
            navigationItem.titleView = searchController.searchBar
        }
        

        
    }
    
    func fetchItems(categoryId: String) {
        SVProgressHUD.showLoader()
        FireStoreManager.getItemsForCategory(categoryId: categoryId) { (error, items) in
            SVProgressHUD.dismiss()
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
        if isSearching {
            return self.searchResults.count
        }
        return self.tableValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ItemCell
        if isSearching {
            let item = self.searchResults[indexPath.row]
            cell.setCell(with: item)
        } else {
            let item = self.tableValues[indexPath.row]
            cell.setCell(with: item)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var item: Item?
        view.endEditing(true)
        if isSearching {
            item = self.searchResults[indexPath.row]
        } else {
            item = self.tableValues[indexPath.row]
        }
        if StorageManager.getCurrentUser() == nil {
            if !isSearching {
                UIAlertController.showLoginAlert()
                //UIAlertController.showAlert(with: "", message: "Please login/signup to proceed")
            }
        } else {
            proceedToItemDetails(item: item!)
        }
    }
}

extension String {
    mutating func addDollarSign() {
        self = "$" + self
    }
}

extension CategoryDetailsController: UISearchBarDelegate {
    func filterContentForSearchText(searchText: String) {
        searchResults = self.tableValues.filter({ (product) -> Bool in
            return product.name!.localizedStandardContains(searchText)
        })
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            isSearching = true
            filterContentForSearchText(searchText: searchText)
            tableView.reloadData()
        } else {
            isSearching = false
            tableView.reloadData()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.resignFirstResponder()
        searchBar.clear()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = true
        view.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let count = searchBar.text?.count {
            if count == 0 {
                isSearching = false
                tableView.reloadData()
            } else {
                isSearching = true
                tableView.reloadData()
            }
        }
    }
}


extension UISearchBar {
    func clear() {
        self.text = nil
    }
}
