//
//  UserDefaultsManager.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 2/2/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import Foundation
import RxSwift

struct ELUserDefaultsManager {
    private static let basketKey = "kBasket"
    private static let wishListKey = "kWishlist"
    private static let userDefaults = UserDefaults.standard
    private static let jsonEncoder = JSONEncoder()
    private static let jsonDecoder = JSONDecoder()
    static let subject = PublishSubject<Int>()
    
    static func addItemToBasket(item: Item) {
        if !isItemInBasket(item: item) {
            if let basket = getBasketArray() {
                var newBasket = basket
                newBasket.append(item)
                subject.onNext(newBasket.count)
                updateBasketArray(basket: newBasket)
            } else {
                var basket = [Item]()
                basket.append(item)
                subject.onNext(basket.count)
                updateBasketArray(basket: basket)
            }
        }
    }
    
    static func addItemToWishlist(item: Item) {
        if !isItemInWishlist(item: item) {
            if let wishlist = getWishlistArray() {
                var newWishlist = wishlist
                newWishlist.append(item)
                updateWishlistArray(wishList: newWishlist)
            } else {
                var wishList = [Item]()
                wishList.append(item)
                updateWishlistArray(wishList: wishList)
            }
        }
    }
    
    static func removeItemFromBasket(item: Item) {
        if isItemInBasket(item: item) {
            if let basket = getBasketArray() {
                var newBasket = basket
                let index = newBasket.index(where: { (neededItem) -> Bool in
                    return neededItem.id == item.id
                })
                if let foundIndex = index {
                    newBasket.remove(at: foundIndex)
                    subject.onNext(newBasket.count)
                    updateBasketArray(basket: newBasket)
                }
            }
        }
    }
    
    static func removeItemFromWishlist(item: Item) {
        if isItemInWishlist(item: item) {
            if let wishlist = getWishlistArray() {
                var newWishlist = wishlist
                let index = newWishlist.index(where: { (neededItem) -> Bool in
                    return neededItem.id ==  item.id
                })
                if let foundIndex = index {
                    newWishlist.remove(at: foundIndex)
                    updateWishlistArray(wishList: newWishlist)
                }
            }
        }
    }
    
    
    private static func isItemInWishlist(item: Item) -> Bool {
        var isInWishlist = false
        if let wishlistArray = getWishlistArray() {
            wishlistArray.forEach({ (wishlistItem) in
                if wishlistItem.id == item.id {
                    isInWishlist = true
                }
            })
        }
        return isInWishlist
    }
    
    private static func isItemInBasket(item: Item) -> Bool {
        var isInBasket = false
        if let basketArray = getBasketArray() {
            basketArray.forEach({ (basketItem) in
                if basketItem.id == item.id {
                    isInBasket = true
                }
            })
        }
        return isInBasket
    }
    
    static func getBasketArray() -> [Item]? {
        var basketArr: [Item]?
        if let encodedData = userDefaults.data(forKey: basketKey) {
            
            if let basket = try? jsonDecoder.decode([Item].self, from: encodedData)  {
                basketArr = basket
            }
        }
        return basketArr
    }
    
    static func getWishlistArray() -> [Item]? {
        var wishListArr: [Item]?
        if let encodedData = userDefaults.data(forKey: wishListKey) {
            if let wishList = try? jsonDecoder.decode([Item].self, from: encodedData) {
                wishListArr = wishList
            }
        }
        return wishListArr
    }
    
    private static func updateBasketArray(basket: [Item]) {
        if let encodedData = try? jsonEncoder.encode(basket) {
            userDefaults.set(encodedData, forKey: basketKey)
        }
    }
    
    private static func updateWishlistArray(wishList: [Item]) {
        if let encodedData = try? jsonEncoder.encode(wishList) {
            userDefaults.set(encodedData, forKey: wishListKey)
        }
    }
    
    private static func getItemFromBasket(item: Item) -> (index: Int?, item: Item?) {
        var foundItem: Item? = nil
        var itemIndex: Int? = nil
        if let basket = getBasketArray() {
            let index = basket.index(where: { (foundItem) -> Bool in
                return item.id == foundItem.id
            })
            if let ind = index {
                foundItem = basket[ind]
                itemIndex = ind
            }
        }
        return (itemIndex, foundItem)
        
    }
    
    static func updateItemCount(item: Item, quantity: Int) {
        if let item =  getItemFromBasket(item: item).item, let index = getItemFromBasket(item: item).index {
            var basket = getBasketArray()!
            basket[index].quantity = quantity
            updateBasketArray(basket: basket)
        } else {
            printD("update failed")
        }
    }
    
    static func clearBasket() {
        updateBasketArray(basket: [Item]())
    }
    
    static func clearWishlist() {
        updateWishlistArray(wishList: [Item]())
    }
}

