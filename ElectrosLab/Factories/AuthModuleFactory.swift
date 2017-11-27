//
//  AuthModuleFactory.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 27/11/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import UIKit

protocol AuthModuleFactory {
    func makeLoginOutput() -> LoginView
    func makeSignupOutput() -> SignupView
}
