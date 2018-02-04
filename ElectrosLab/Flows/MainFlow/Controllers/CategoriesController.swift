//
//  CategoriesController.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 7/1/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseFirestore

protocol CategoriesView: BaseView {
  //  var didSelectCategory:(() -> CategoryItem?) { get set }
}

class CategoriesController: UIViewController, CategoriesView {

    @IBOutlet weak var tableView: UITableView!
    var tableValues = [CategoryItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchCategories()
    }
    
    func setupTableView() {
        tableView.register(CategoriesCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    func fetchCategories() {
        SVProgressHUD.show()
        var categoriesArray = [CategoryItem]()
        FireStoreManager.fireStoreGetQuery(documentPath: FirestoreDocumentPath.categories.rawValue) { (error, documentsArray) in
            SVProgressHUD.dismiss()

            if error != nil {
                UIAlertController.showErrorAlert()
            } else {
                if let result = documentsArray {
                    result.forEach({ (doc) in
                        let category = CategoryItem(from: doc.data()!, id: doc.documentID)
                        categoriesArray.append(category)
                    })
                    self.tableValues = categoriesArray
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func showCategoryDetails(category: CategoryItem) {
        let categoryDetailsController = CategoryDetailsController.controllerInStoryboard(.store)
        categoryDetailsController.category = category
        navigationController?.pushViewController(categoryDetailsController, animated: true)
    }
}

extension CategoriesController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}


extension CategoriesController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CategoriesCell
        let item = self.tableValues[indexPath.row]
        cell.setCellWithCategoryItem(category: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.tableValues[indexPath.row]
        showCategoryDetails(category: item)
    }
}
