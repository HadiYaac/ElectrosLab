//
//  NewsController.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 14/1/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit
import FirebaseFirestore
import SVProgressHUD

protocol NewsView: BaseView {
    
}

class NewsController: UIViewController, NewsView {
   
    @IBOutlet weak var tableView: UITableView!
    var tableValues = [NewsItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchNews()
    }
    
    func fetchNews() {
        SVProgressHUD.show()
        let db = Firestore.firestore()
        var newsItems = [NewsItem]()
        db.collection(FirestoreDocumentPath.news.rawValue).getDocuments { (querySnapshot, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                UIAlertController.showAlert(with: "", message: error.localizedDescription)
            } else {
                if let documents = querySnapshot?.documents {
                    documents.forEach({ (doc) in
                        printD(doc.data())
                        let newsItem = NewsItem(from: doc.data())
                        newsItems.append(newsItem)
                    })
                    self.tableValues = newsItems
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.register(NewsCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.electrosLabBlue()
    }
    
    func setupNavigationBar() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
        }
    }

}

extension NewsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as NewsCell
        let item = tableValues[indexPath.row]
        cell.setupCell(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
