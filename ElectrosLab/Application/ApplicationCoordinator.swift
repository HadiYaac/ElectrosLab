//
//  ApplicationCoordinator.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 27/11/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import Foundation

fileprivate enum LaunchInstructor {
    case home, auth
    static func configure(isLoggedIn: Bool = false) -> LaunchInstructor {
        if isLoggedIn {
            return .home
        } else {
            return .auth
        }
    }
}

final class ApplicationCoordinator: BaseCoordinator {
    
    private let router: Router
    private let coordinatorFactory: CoordinatorFactory
    private var instructor: LaunchInstructor {
        return LaunchInstructor.configure()
    }
    
    init(router: Router, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        switch instructor {
        case .auth:
            runAuthFlow()
        case .home:
            runHomeFlow()
        }
    }
    
    private func runAuthFlow() {
        let coordinator = coordinatorFactory.makeAuthCoordinator(router: router)
        coordinator.finishFlow = { [weak self] in
            printD("AuthFlow Finished")
            self?.runHomeFlow()
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runHomeFlow() {
        
    }
    
    
}
