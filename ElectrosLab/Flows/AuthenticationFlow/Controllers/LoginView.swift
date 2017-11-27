//
//  LoginView.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 27/11/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import Foundation

protocol LoginView: BaseView {
    var userAuthenticated:(() -> Void)? { set get }
    var onSignupTap:(() -> Void)? { set get }
    var onGuestTap:(() -> Void)? { set get }
}
