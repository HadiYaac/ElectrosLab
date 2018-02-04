//
//  LoginController.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 27/11/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseAuth

class LoginController: UIViewController, LoginView {

    var userAuthenticated: (() -> Void)?
    var onGuestTap: (() -> Void)?
    var onSignupTap: (() -> Void)?
    
    @IBOutlet weak var passwordTxtfield: HJFloatingLabelTextField!
    @IBOutlet weak var phoneNumberTxtfield: HJFloatingLabelTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var guestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        view.backgroundColor = UIColor.electrosLabBlue()
        setupNavigationBar()
        #if DEBUG
            phoneNumberTxtfield.text = "hu@me.com"
            passwordTxtfield.text = "123456"
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTextFields()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.electrosLabBlue()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    func setupTextFields() {
        phoneNumberTxtfield.setupBottomBorder(color: UIColor.white)
        passwordTxtfield.setupBottomBorder(color: UIColor.white)
        phoneNumberTxtfield.placeholder = "Email Address"
        passwordTxtfield.placeholder = "Password"
        passwordTxtfield.isSecureTextEntry = true
        phoneNumberTxtfield.keyboardType = .emailAddress
        phoneNumberTxtfield.textColor = UIColor.white
        passwordTxtfield.textColor = UIColor.white
        phoneNumberTxtfield.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        passwordTxtfield.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
    
    func setupButtons() {
        loginButton.backgroundColor = UIColor.white
        signUpButton.backgroundColor = UIColor.white
        guestButton.backgroundColor = UIColor.white
        
        loginButton.setTitleColor(UIColor.electrosLabBlue(), for: .normal)
        signUpButton.setTitleColor(UIColor.electrosLabBlue(), for: .normal)
        guestButton.setTitleColor(UIColor.electrosLabBlue(), for: .normal)
    }

    @IBAction func loginAction(_ sender: Any) {
        if let email = phoneNumberTxtfield.text, let password = passwordTxtfield.text {
            SVProgressHUD.showLoader()
            FireStoreManager.loginAction(email: email, password: password) { (error, user) in
                if let error = error {
                    SVProgressHUD.dismissLoader()
                    UIAlertController.showAlert(with: "", message: error.localizedDescription)
                } else {
                    self.updateUser(user: user!)
                }
            }
        } else {
            UIAlertController.showAlert(with: "", message: "Fill all fields")
        }
    }
    
    func updateUser(user: User) {
        FireStoreManager.getUserFromFireStoreDB(user: user) { (error, userData) in
            SVProgressHUD.dismissLoader()
            if let error = error  {
                UIAlertController.showAlert(with: "", message: error.localizedDescription)
            } else {
                self.userAuthenticated?()
                printD(userData!)
            }
        }
    }
    
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        self.onSignupTap?()
    }
    
    @IBAction func guestTapped(_ sender: UIButton) {
        self.onGuestTap?()
    }
}

