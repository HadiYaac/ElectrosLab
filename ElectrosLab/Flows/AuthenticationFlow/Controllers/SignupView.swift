//
//  SignupView.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 27/11/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import Foundation

protocol SignupView: BaseView {
    var userDidSignup: (() -> Void)? { get set }
}
