//
//  ModuleFactoryImp.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 27/11/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import Foundation

final class ModuleFactoryImp: AuthModuleFactory {
    func makeLoginOutput() -> LoginView {
        return LoginController.controllerInStoryboard(.auth)
    }
    
    func makeSignupOutput() -> SignupView {
        return SignupController.controllerInStoryboard(.auth)
    }
    
    
}
