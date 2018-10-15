//
//  FireStoreManager.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 20/1/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

enum FirestoreDocumentPath: String {
    case categories = "categories"
    case news = "news"
    case users = "users"
    case items = "items"
    case orders = "orders"
    case notifications
}

final class FireStoreManager {
    static func fireStoreGetQuery(documentPath: String, completion: @escaping (_ error: Error?, _ result: [DocumentSnapshot]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(documentPath).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(error, nil)
            } else {
                if let result = querySnapshot?.documents {
                    completion(nil, result)
                } else {
                    completion(error, nil)
                }
            }
        }
    }
    
    static func getItemsForCategory(categoryId: String, completion: @escaping (_ error: Error?, _ result: [Item]?) -> ()) {
        let db = Firestore.firestore()
        let itemsRef = db.collection(FirestoreDocumentPath.items.rawValue)
        let query = itemsRef.whereField("category_id", isEqualTo: categoryId)
        query.getDocuments { (snapshot, error) in
            if error != nil {
                completion(error, nil)
            } else {
                if let documents = snapshot?.documents {
                    var itemsArray = [Item]()
                    for doc in documents {
                        let item = Item(from: doc.data(), id: doc.documentID)
                        itemsArray.append(item)
                    }
                    completion(nil, itemsArray)
                } else {
                    completion(error, nil)
                }
            }
        }
    }
    
    static func getNotifications(completion: @escaping (_ notifications: [NotificationItem]?, _ error: Error?) -> ()) {
        let db = Firestore.firestore()
        let notificationsRef = db.collection(FirestoreDocumentPath.notifications.rawValue)
        notificationsRef.getDocuments { (snapshot, error) in
            if error != nil {
                completion(nil, error)
            } else {
                if let documents = snapshot?.documents {
                    var items = [NotificationItem]()
                    for doc in documents {
                        let item = NotificationItem(from: doc.data(), id: doc.documentID)
                        items.append(item)
                    }
                    completion(items, nil)
                } else {
                    completion(nil, error)
                }
            }
        }
    }
    
    static func signupUser(email: String, password: String, completion: @escaping (_ error: Error?, _ user: User?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            completion(error, user)
        }
    }
    
    static func updateUserInFirestoreDB(user: User, params: [String : Any], completion: @escaping (_ error: Error?) -> ()) {
        let db = Firestore.firestore()
        let userid = user.uid
        var params = params
        params["id"] = userid
        // TODO: Add user to session manager
        db.collection(FirestoreDocumentPath.users.rawValue).document(userid).setData(params) { (error) in
            completion(error)
        }
    }
    
    static func loginAction(email: String, password: String, completion: @escaping (_ error: Error?, _ user: User?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            completion(error, user)
        }
    }
    
    static func getUserFromFireStoreDB(user: User, completion: @escaping (_ error: Error?, _ userData: [String : Any]?) -> ()) {
        let db = Firestore.firestore()
        let userId = user.uid
        db.collection(FirestoreDocumentPath.users.rawValue).document(userId).getDocument { (documentSnapshot, error) in
            if error != nil {
                completion(error, nil)
            } else {
                //TODO: add user to session manager
                completion(nil, documentSnapshot?.data())
            }
        }
    }
    
    static func fetchUserOrders(completion: @escaping (_ orders: [Order]?, _ error: Error? ) -> ()) {
        guard let userId = StorageManager.getCurrentUser()?.id else {
            return
        }
        let db = Firestore.firestore()
        let ref = db.collection(FirestoreDocumentPath.orders.rawValue)
        let query = ref.whereField(FieldPath(["user", "user_id"]), isEqualTo: userId)
        query.getDocuments { (snapshot, error) in
            if error != nil {
                completion(nil, error)
            } else {
                let docs = snapshot?.documents
                var ordersArray = [Order]()
                for doc in docs! {
                    let order = Order(from: doc.data(), id: doc.documentID)
                    ordersArray.append(order)
                }
                completion(ordersArray, nil)
            }
        }
    }
    
    static func uploadNewOrder(orderItems: [Item], completion: @escaping (_ error: Error?, _ success: Bool) -> ()) {
        let db = Firestore.firestore()
        var orderDictionary = [String : Any]()
        orderDictionary["user"] = StorageManager.getCurrentUser()!.getUserDictionary()
        orderDictionary["total"] = getTotalPriceString(items: orderItems)
        var itemsDictionary = [[String : Any]]()
        orderItems.forEach { (item) in
            let itemDic = item.itemDictionary()
            itemsDictionary.append(itemDic)
        }
        orderDictionary["items"] = itemsDictionary
        orderDictionary["created_at"] = "\(NSDate().timeIntervalSince1970)"
        
        db.collection(FirestoreDocumentPath.orders.rawValue).addDocument(data: orderDictionary) { (error) in
            if error != nil {
                completion(error, false)
            } else {
                completion(nil, true)
            }
        }
    }
    
    private static func getTotalPriceString(items: [Item]) -> String {
        var totalPrice: Float = 0.0
        items.forEach { (item) in
            let quantity = item.quantity
            let price = item.price!
            let total = Float(quantity) * price
            totalPrice = totalPrice + total
            
        }
        var totalPriceString = "\(totalPrice)"
        totalPriceString.addDollarSign()
        return totalPriceString
    }
}


