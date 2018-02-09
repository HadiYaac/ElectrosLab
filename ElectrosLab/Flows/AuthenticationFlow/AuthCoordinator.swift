//
//  AuthCoordinator.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 27/11/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import UIKit

final class AuthCoordinator: BaseCoordinator, AuthCoordinatorOutput {
    var finishFlow: (() -> Void)?
    private let factory: AuthModuleFactory
    private let router: Router
    
    init(router: Router, factory: AuthModuleFactory) {
        self.router = router
        self.factory = factory
    }
    
    override func start() {
        if StorageManager.getCurrentUser() != nil {
            self.finishFlow?()
        } else {
            showLogin()
        }
    }
    
    private func showLogin() {
        let loginOutput = factory.makeLoginOutput()
        loginOutput.userAuthenticated = { [weak self] in
            printD("Go to home")
            self?.finishFlow?()
        }
        loginOutput.onGuestTap = { [weak self] in
            printD("Guest login")
            self?.finishFlow?()
        }
        loginOutput.onSignupTap = { [weak self] in
            printD("go to sign up")
            self?.showSignUp()
        }
        router.setRootModule(loginOutput)
    }
    
    private func showSignUp() {
        let singupOutput = factory.makeSignupOutput()
        singupOutput.userDidSignup = { [weak self] in
            self?.finishFlow?()
        }
        router.push(singupOutput)
    }
}
