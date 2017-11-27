//
//  Presentable.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 27/11/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import UIKit
/// protocol to be implemeted by any object wants to present a controller
protocol Presentable {
    /// - Returns: the view controller of the conformed object
    func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
    /// Since this function might returns a view controller and this object here is a view controller so the return value will be self.
    func toPresent() -> UIViewController? {
        return self
    }
}
