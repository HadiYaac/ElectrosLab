//
//  CoordinatorFactoryImp.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 27/11/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import UIKit

final class CoordinatorFactoryImp: CoordinatorFactory {
    
    private func navigationController(_ navController: UINavigationController?) -> UINavigationController {
        if let navController = navController {
            return navController
        }
        return UINavigationController.controllerInStoryboard(.main)
    }
    
    private func router(_ navController: UINavigationController?) -> Router {
        return RouterImp(rootViewController: navigationController(navController))
    }
    
    func makeAuthCoordinator(router: Router) -> AuthCoordinatorOutput & Coordinator {
        let coordinator = AuthCoordinator(router: router, factory: ModuleFactoryImp())
        return coordinator
    }
    
    
    func makeTabbarCoordinator() -> (configurator: Coordinator, toPresent: Presentable?) {
        let controller = TabbarController.controllerInStoryboard(.main)
        let coordinator = TabbarCoordinator(tabbarView: controller, coordinatorFactory: CoordinatorFactoryImp())
        return (coordinator, controller)
    }
}
