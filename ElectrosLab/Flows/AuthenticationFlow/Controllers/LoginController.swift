//
//  LoginController.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 27/11/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import UIKit

class LoginController: UIViewController, LoginView {

    var userAuthenticated: (() -> Void)?
    var onGuestTap: (() -> Void)?
    var onSignupTap: (() -> Void)?
    
    @IBOutlet weak var passwordTxtfield: HJFloatingLabelTextField!
    @IBOutlet weak var phoneNumberTxtfield: HJFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTextFields()
    }
    
    func setupTextFields() {
        phoneNumberTxtfield.setupBottomBorder()
        passwordTxtfield.setupBottomBorder()
        phoneNumberTxtfield.placeholder = "Phone number"
        passwordTxtfield.placeholder = "Password"
        passwordTxtfield.isSecureTextEntry = true
        phoneNumberTxtfield.keyboardType = .phonePad
    }

    @IBAction func loginAction(_ sender: Any) {
        self.userAuthenticated?()
    }
    @IBAction func signUpTapped(_ sender: UIButton) {
        self.onSignupTap?()
    }
    
    @IBAction func guestTapped(_ sender: UIButton) {
        self.onGuestTap?()
    }
}
