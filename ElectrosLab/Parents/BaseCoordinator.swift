//
//  BaseCoordinator.swift
//  Trellis
//
//  Created by Ibrahim Kteish on 3/24/17.
//  Copyright © 2017 Ibrahim Kteish. All rights reserved.
//

import Foundation

enum SelectedController {
    case pendingController
}

///A base class holding the management of any root controller's coordinators
class BaseCoordinator: Coordinator {
    func startWithController(_ controller: SelectedController?) { }
    
    ///Holds the sub-coordinators
    var childCoordinators: [Coordinator] = []
    
    func start() {
        start()
    }
    
    //func start(with option: DeepLinkOption?) { }
    
    //Add only unique object
    func addDependency(_ coordinator: Coordinator) {
        
        if childCoordinators.isEmpty {
            childCoordinators.append(coordinator)
            return
        }
        for element in childCoordinators where element !== coordinator {
            childCoordinators.append(coordinator)
        }
    }
    //remove coordinator object if exists
    func removeDependency(_ coordinator: Coordinator?) {
        guard childCoordinators.isEmpty == false, let coordinator = coordinator else {
            return
        }
        
        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
        }
    }
}
