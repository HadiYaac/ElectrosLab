//
//  TabbarCoordinator.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 7/1/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import Foundation

import UIKit

final class TabbarCoordinator: BaseCoordinator {
    
    private let tabbarView: TabbarView
    private let coordinatorFactory: CoordinatorFactory
    
    init(tabbarView: TabbarView, coordinatorFactory: CoordinatorFactory) {
        self.tabbarView = tabbarView
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        tabbarView.didPressBasket = startBasketFlow()
//        tabbarView.onViewDidLoad = runMeasureFlow()
//        tabbarView.onMeasureFlowSelect = runMeasureFlow()
    }
    
    override func startWithController(_ controller: SelectedController?) {
//        tabbarView.onViewDidLoad = runMeasureFlow(controller: controller)
//        tabbarView.onMeasureFlowSelect = runMeasureFlow(controller: controller)
    }
    
    private func startBasketFlow() -> ((UINavigationController) -> Void) {
        return { navController in
            let basketOutput = BasketController.controllerInStoryboard(.basket)
            navController.pushViewController(basketOutput, animated: true)
            
        }
    }
    
    private func runMeasureFlow(controller: SelectedController? = nil) -> ((UINavigationController) -> Void) {
        
        return { navController in
            if navController.viewControllers.isEmpty == true {

            }
        }
    }
}
