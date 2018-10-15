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
//        var loggedIn = isLoggedIn
//        if StorageManager.getCurrentUser() != nil {
//            loggedIn = true
//        }
//        if loggedIn {
//            return .home
//        } else {
//            return .auth
//        }
        return .home
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
        NotificationCenter.default.addObserver(self, selector: #selector(runAuthFlow), name: NSNotification.Name(rawValue: "logout"), object: nil)
        switch instructor {
        case .auth:
            runAuthFlow()
        case .home:
            runHomeFlow()
        }
    }
    
    @objc private func runAuthFlow() {
        let coordinator = coordinatorFactory.makeAuthCoordinator(router: router)
        coordinator.finishFlow = { [weak self] in
            printD("AuthFlow Finished")
            self?.runHomeFlow()
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runHomeFlow() {
        let (coordinator, module) = coordinatorFactory.makeTabbarCoordinator()
        addDependency(coordinator)
        router.setRootModule(module)
        coordinator.start()
    }
    
    
}
