//
//  RouterImp.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 27/11/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import Foundation


import UIKit

final class RouterImp: NSObject, Router {
    
    private weak var rootController: UINavigationController?
    private var completions: [UIViewController: () -> Void] = [:]
    
    init(rootViewController: UINavigationController) {
        self.rootController = rootViewController
    }
    
    //Private Methods
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else {
            return
        }
        completion()
        completions.removeValue(forKey: controller)
    }
    
    //Presentable Protocol Impl
    func toPresent() -> UIViewController? {
        return rootController
    }
    
    //Router Protocol Impl
    func present(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent() else {
            return
        }
        rootController?.present(controller, animated: animated, completion: nil)
    }
    
    func present(_ module: Presentable?) {
        present(module, animated:true)
    }
    
    func display(_ module: Presentable?) {
        self.rootController?.topViewController?.TRSAddChildViewController((module?.toPresent())!)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        rootController?.dismiss(animated: animated, completion: completion)
    }
    
    func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }
    
    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
        guard let controller = module?.toPresent(), (controller is UINavigationController == false)
            else {
                assertionFailure("Deprecated push UINavigationController.")
                return
        }
        
        if let completion = completion {
            completions[controller] = completion
        }
        
        rootController?.pushViewController(controller, animated: animated)
    }
    
    func push(_ module: Presentable?, animated: Bool) {
        push(module, animated: animated, completion: nil)
    }
    
    func push(_ module: Presentable?) {
        push(module, animated: true)
    }
    
    func popModule(animated: Bool) {
        if let controller = rootController?.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    func popModule() {
        popModule(animated: true)
    }
    
    func setRootModule(_ module: Presentable?) {
        setRootModule(module, hideBar: false)
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool) {
        guard let controller = module?.toPresent() else {
            return
        }
        rootController?.setViewControllers([controller], animated: false)
        rootController?.isNavigationBarHidden = hideBar
    }
    
    func popToRootModule(animated: Bool) {
        if let controllers = rootController?.popToRootViewController(animated: animated) {
            controllers.forEach { runCompletion(for: $0) }
        }
    }
}
