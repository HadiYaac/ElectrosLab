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
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        view.backgroundColor = UIColor.white
        #if DEBUG
            phoneNumberTxtfield.text = "hu@me.com"
            passwordTxtfield.text = "123456"
        #endif
        
        forgotPasswordButton.setTitleColor(UIColor.electrosLabDarkGreen(), for: .normal)
        forgotPasswordButton.setTitle("Forgot Password?", for: .normal)
    }
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: "", message: "By entering your email address and pressing submit, you'll get an email to help you reset your password", preferredStyle: .alert)
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Email Address"
            textfield.keyboardType = .emailAddress
        }
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (action) in
            SVProgressHUD.showLoader()
            if let email = alertController.textFields?.first?.text {
                Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
                    SVProgressHUD.dismiss()
                    if let error = error {
                        UIAlertController.showAlert(with: "", message: error.localizedDescription)
                        
                    } else {
                        UIAlertController.showAlert(with: "", message: "Please check your email inbox to proceed with resetting your password.")
                    }
                })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTextFields()
    }
    
    func setupTextFields() {
        phoneNumberTxtfield.setupBottomBorder(color: UIColor.white)
        passwordTxtfield.setupBottomBorder(color: UIColor.white)
        phoneNumberTxtfield.placeholder = "Email Address"
        passwordTxtfield.placeholder = "Password"
        passwordTxtfield.isSecureTextEntry = true
        phoneNumberTxtfield.keyboardType = .emailAddress
        phoneNumberTxtfield.textColor = UIColor.electrosLabDarkGreen()
        passwordTxtfield.textColor = UIColor.electrosLabDarkGreen()
        phoneNumberTxtfield.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        passwordTxtfield.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
    }
    
    func setupButtons() {
        loginButton.backgroundColor = UIColor.electrosLabDarkGreen()
        signUpButton.backgroundColor = UIColor.electrosLabDarkGreen()
        guestButton.backgroundColor = UIColor.clear
        
        loginButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        guestButton.setTitleColor(UIColor.electrosLabDarkGreen(), for: .normal)
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
                let currentUser = ELUser(from: userData!, userId: user.uid)
                StorageManager.saveCurrentUser(user: currentUser)
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

