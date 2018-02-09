//
//  SignupController.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 27/11/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD


class SignupController: UIViewController, SignupView {

    @IBOutlet weak var fullNameTextField: HJFloatingLabelTextField!
    @IBOutlet weak var phoneNumberTextField: HJFloatingLabelTextField!
    @IBOutlet weak var emailAddressTextField: HJFloatingLabelTextField!
    
    @IBOutlet weak var passwordTextField: HJFloatingLabelTextField!
    @IBOutlet weak var confirmPasswordTextField: HJFloatingLabelTextField!
    @IBOutlet weak var cityTextfield: HJFloatingLabelTextField!
    @IBOutlet weak var streetTextField: HJFloatingLabelTextField!
    @IBOutlet weak var buildingTextField: HJFloatingLabelTextField!
    @IBOutlet weak var floorTextField: HJFloatingLabelTextField!
    @IBOutlet weak var signupButton: UIButton!
    
    var userDidSignup: (() -> Void)?
    
    var isEditingProfile: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        signupButton.backgroundColor = UIColor.electrosLabBlue()
        setupView()
    }
    
    func setupView() {
        if isEditingProfile {
            title = "Edit Profile"
            signupButton.setTitle("Save Changes", for: .normal)
            fillFieldsWithUser()
        } else {
            title = "Sign Up"
            signupButton.setTitle("Sign Up", for: .normal)
        }
    }
    
    func fillFieldsWithUser() {
        passwordTextField.isHidden = true
        confirmPasswordTextField.isHidden = true
        emailAddressTextField.isEnabled = false
        if let user = StorageManager.getCurrentUser() {
            fullNameTextField.text = user.name
            phoneNumberTextField.text = user.phoneNumber
            emailAddressTextField.text = user.email
            cityTextfield.text = user.city
            streetTextField.text = user.street
            buildingTextField.text = user.building
            floorTextField.text = user.floor
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTextFields()
    }
    
    func setupTextFields() {
        setupTextFieldWithBorder(textField: fullNameTextField, placeholder: "Full Name")
        setupTextFieldWithBorder(textField: phoneNumberTextField, placeholder: "Phone Number (Optional)")
        phoneNumberTextField.keyboardType = .phonePad
        
        setupTextFieldWithBorder(textField: emailAddressTextField, placeholder: "Email Address (this will be used to login to the app)")
        emailAddressTextField.keyboardType = .emailAddress
        
        setupTextFieldWithBorder(textField: passwordTextField, placeholder: "Password")
        passwordTextField.isSecureTextEntry = true
        
        setupTextFieldWithBorder(textField: confirmPasswordTextField, placeholder: "Confirm Password")
        confirmPasswordTextField.isSecureTextEntry = true
        setupTextFieldWithBorder(textField: cityTextfield, placeholder: "City")
        setupTextFieldWithBorder(textField: streetTextField, placeholder: "Street")
        setupTextFieldWithBorder(textField: buildingTextField, placeholder: "Building Name")
        setupTextFieldWithBorder(textField: floorTextField, placeholder: "Floor")
    }
    
    func setupTextFieldWithBorder(textField: HJFloatingLabelTextField ,placeholder: String) {
        textField.placeholder = placeholder
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
        textField.setupBottomBorder(color: UIColor.electrosLabBlue())
        textField.textColor = UIColor.electrosLabBlue()
    }
    
    func setupNavigationBar() {
        if #available(iOS 11, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        }
        
    }
    
    func buildRegistrationDictionary() -> [String : Any] {
        var params = [String : Any]()
        if let name = fullNameTextField.text {
            params["name"] = name
        }
        if let phone = phoneNumberTextField.text {
            params["phone_number"] = phone
        }
        if let email = emailAddressTextField.text {
            params["email"] = email
        }
//        if let password = passwordTextField.text {
//            params["password"] = password
//        }
        if let city = cityTextfield.text {
            params["city"] = city
        }
        if let street = streetTextField.text {
            params["street"] = street
        }
        if let building = buildingTextField.text {
            params["building"] = building
        }
        if let floor = floorTextField.text {
            params["floor"] = floor
        }
        return params
    }
    
    func didFillRequiredFields() -> Bool {
        let filled = fullNameTextField.isFilled() && emailAddressTextField.isFilled() && passwordTextField.isFilled() && confirmPasswordTextField.isFilled() && cityTextfield.isFilled() && streetTextField.isFilled() && buildingTextField.isFilled() && floorTextField.isFilled()
        return filled
    }
    
    func passwordsMatching() -> Bool {
        if confirmPasswordTextField.isFilled() && passwordTextField.isFilled() {
            if let password = passwordTextField.text, let confirmedPassword = confirmPasswordTextField.text {
                return password == confirmedPassword
            }
        }
        return false
    }
    
    func generateErrorMessage() -> String {
        var errorMessage = "field is required"
        if !fullNameTextField.isFilled() {
            errorMessage = "Name ".appending(errorMessage)
        } else if !emailAddressTextField.isFilled() {
            errorMessage = "Email ".appending(errorMessage)
        } else if !passwordTextField.isFilled() {
            errorMessage = "Password " + errorMessage
        } else if !confirmPasswordTextField.isFilled() {
            errorMessage = "Confirm password " + errorMessage
        } else if !cityTextfield.isFilled() {
            errorMessage = "City " + errorMessage
        } else if !streetTextField.isFilled() {
            errorMessage = "Street " + errorMessage
        } else if !buildingTextField.isFilled() {
            errorMessage = "Building " + errorMessage
        } else if !floorTextField.isFilled() {
            errorMessage = "Floor ".appending(errorMessage)
        } else if !passwordsMatching() {
            errorMessage = "Passwords are not matching"
        }
        return errorMessage
    }
    
    @IBAction func signupAction(_ sender: UIButton) {
        if isEditingProfile {
            let params = buildRegistrationDictionary()
            if let user = Auth.auth().currentUser {
                SVProgressHUD.showLoader()
                FireStoreManager.updateUserInFirestoreDB(user: user, params: params, completion: { (error) in
                    SVProgressHUD.dismiss()
                    if let error = error {
                        UIAlertController.showAlert(with: "", message: error.localizedDescription)
                    } else {
                        let newUser = ELUser(from: params, userId: user.uid)
                        StorageManager.saveCurrentUser(user: newUser)
                        self.navigationController?.popViewController(animated: true)
                        UIAlertController.showAlert(with: "", message: "Your info has been updated successfully")
                    }
                })
            }
        } else {
            if didFillRequiredFields() && passwordsMatching() {
                signup()
            } else {
                UIAlertController.showAlert(with: "", message: generateErrorMessage())
            }
        }
        

    }
    
    func signup() {
        
        if let email = emailAddressTextField.text, let password = passwordTextField.text {
            SVProgressHUD.showLoader()
            FireStoreManager.signupUser(email: email, password: password, completion: { (error, user) in
                SVProgressHUD.dismiss()
                if let user = user {
                    self.updateUserObjectInFSDB(user: user, params: self.buildRegistrationDictionary())
                } else if let error = error {
                    UIAlertController.showAlert(with: "", message: error.localizedDescription)
                } else {
                    UIAlertController.showErrorAlert()
                }
            })
        }
    }
    
    func updateUserObjectInFSDB(user: User, params: [String : Any]) {
        SVProgressHUD.showLoader()
        FireStoreManager.updateUserInFirestoreDB(user: user, params: params) { (error) in
            SVProgressHUD.dismiss()
            if let error = error {
                UIAlertController.showAlert(with: "", message: error.localizedDescription)
            } else {
                let currentUser = ELUser(from: params, userId: user.uid)
                StorageManager.saveCurrentUser(user: currentUser)
                self.userDidSignup?()
            }
        }
    }
    

    
}

extension UITextField {
    func isFilled() -> Bool {
        var filled = false
        if let text = self.text, text.count > 0 {
            filled = true
        }
        return filled
    }
}
