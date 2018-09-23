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
import ImageSlideshow

protocol CategoriesView: BaseView {
}

class CategoriesController: UIViewController, CategoriesView {

    @IBOutlet weak var tableView: UITableView!
    var tableValues = [CategoryItem]()
    var imageSlideShow: ImageSlideshow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageSlideShowView()
        setupTableView()
        fetchCategories()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        imageSlideShow.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func didTap() {
        imageSlideShow.presentFullScreenController(from: self)
    }
    
    
    /*
     slideshow.setImageInputs([
     ImageSource(image: UIImage(named: "myImage"))!,
     ImageSource(image: UIImage(named: "myImage2"))!,
     AlamofireSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080"),
     KingfisherSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080"),
     ParseSource(file: PFFile(name:"image.jpg", data:data))
     ])
     */
    private func setupImageSlideShowView() {
        imageSlideShow = ImageSlideshow(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        imageSlideShow.circular = true
        imageSlideShow.slideshowInterval = 2.0
        imageSlideShow.setImageInputs([
            ImageSource(image: UIImage.init(named: "1.jpg")!),
            ImageSource(image: UIImage.init(named: "2.jpeg")!),
            ImageSource(image: UIImage.init(named: "3.jpeg")!),
            ImageSource(image: UIImage.init(named: "4.jpeg")!),
            ImageSource(image: UIImage.init(named: "5.jpeg")!),
            ImageSource(image: UIImage.init(named: "6.jpeg")!),
            ImageSource(image: UIImage.init(named: "7.jpeg")!),
            ImageSource(image: UIImage.init(named: "8.jpeg")!),
            ImageSource(image: UIImage.init(named: "9.jpeg")!),
            ImageSource(image: UIImage.init(named: "10.jpeg")!),
            ImageSource(image: UIImage.init(named: "11.jpeg")!)
            ])
        imageSlideShow.contentScaleMode = .scaleAspectFill
        imageSlideShow.zoomEnabled = true
    }
    
    func setupTableView() {
        tableView.register(CategoriesCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = imageSlideShow
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
