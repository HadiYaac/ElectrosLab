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
    
    static func uploadNewOrder(orderItems: [Item], completion: @escaping (_ error: Error?, _ success: Bool) -> ()) {
        let db = Firestore.firestore()
        let userId = Auth.auth().currentUser?.uid
        var orderDictionary = [String : Any]()
        orderDictionary["user_id"] = userId!
        orderDictionary["total"] = getTotalPriceString(items: orderItems)
        var itemsDictionary = [[String : Any]]()
        orderItems.forEach { (item) in
            let itemDic = ["item_id": item.id!, "count": item.quantity] as [String : Any]
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


