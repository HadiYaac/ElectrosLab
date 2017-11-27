//
//  UserInputValidators.swift
//  Trellis
//
//  Created by Ibrahim on 5/10/17.
//  Copyright © 2017 Ibrahim Kteish. All rights reserved.
//

import Foundation

/// Enum holds a validaton result, each validator is going to respond with whether the input it was given was valid or not. If it is not valid, it will return some type of error explaining why.
enum ValidatorResult {
    case valid
    case invalid(errors: [Error])
}
/// extend `ValidatorResult` by adding a bool variable
extension ValidatorResult {
    /// if the result is valid it will return true, false otherwise
    var bool: Bool {
        if case .valid = self {
            return true
        }
        return false
    }
}
/// Protocol to be implemented by a validator class/struct
protocol Validator {
    /// Validate a string were each validator is going to have a function that accepts the value as a String and returns a ValidatorResult.
    /// - Parameter value: the string to validate
    /// Returns: ValidatorResult
    func validate(_ value: String) -> ValidatorResult
}
/// text validator error types
enum TextValidatorError: Error {
    case empty
    case tooShort
    case invalidFormat
    case notEnglish
}
/// EMail validator error types
enum EmailValidatorError: Error {
    case empty
    case invalidFormat
}
/// Password validator error types
enum PasswordValidatorError: Error {
    case empty
    case tooShort
    case noUppercaseLetter
    case noLowercaseLetter
    case noNumber
}

enum PhoneNumberValidatorError: Error {
    case notNumeric
}

/// struct to check if a string is not empty or not
struct EmptyStringValidator: Validator {
    
    // This error is passed via the initializer to allow this validator to be reused
    private let invalidError: Error
    
    init(invalidError: Error) {
        self.invalidError = invalidError
    }
    
    func validate(_ value: String) -> ValidatorResult {
        if value.isEmpty {
            return .invalid(errors: [invalidError])
        } else {
            return .valid
        }
    }
}

/// struct to check the length of string. By default the min length is 8 chars.
struct StringLengthValidator: Validator {
    
    // This error is passed via the initializer to allow this validator to be reused
    private let invalidError: Error
    private let minLength: Int
    
    init(invalidError: Error, minLength: Int = 8) {
        self.minLength = minLength
        self.invalidError = invalidError
    }
    
    func validate(_ value: String) -> ValidatorResult {
        if value.count < minLength {
            return .invalid(errors: [invalidError])
        } else {
            return .valid
        }
    }
}

/// struct to check if name contains only english letters and spaces
struct EnglishNameValidator: Validator {
    func validate(_ value: String) -> ValidatorResult {
        let englishRegEx = "^[a-zA-Z' ]+$"
        let englishNameTest = NSPredicate(format: "SELF MATCHES %@", englishRegEx)
        if englishNameTest.evaluate(with: value) {
            return .valid
        } else {
            return .invalid(errors: [TextValidatorError.notEnglish])
        }
    }
}
/// struct to check if a string is email formatted.
struct EmailFormatValidator: Validator {
    func validate(_ value: String) -> ValidatorResult {
        
        let emailRegEx = "[A-Z0-9a-z._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if emailTest.evaluate(with: value) {
            return .valid
        } else {
            return .invalid(errors: [EmailValidatorError.invalidFormat])
        }
    }
}
/// struct to check if a string has uppercase character/s
struct UppercaseLetterValidator: Validator {
    
    func validate(_ value: String) -> ValidatorResult {
        let uppercaseLetterRegex = ".*[A-Z]+.*"
        
        let uppercaseLetterTest = NSPredicate(format:"SELF MATCHES %@", uppercaseLetterRegex)
        
        if uppercaseLetterTest.evaluate(with: value) {
            return .valid
        } else {
            return .invalid(errors: [PasswordValidatorError.noUppercaseLetter])
        }
    }
}

/// struct to check if a string is composed of only digits
struct PhoneNumberValidator: Validator {
    func validate(_ value: String) -> ValidatorResult {
        if value.isNumeric {
            return .valid
        } else {
            return .invalid(errors: [PhoneNumberValidatorError.notNumeric])
        }
    }
}

/// struct to compose multiple validators
struct CompositeValidator: Validator {
    
    private let validators: [Validator]
    
    init(validators: Validator...) {
        self.validators = validators
    }
    
    func validate(_ value: String) -> ValidatorResult {
        return validators.reduce(.valid) { validatorResult, validator in
            switch validator.validate(value) {
            case .valid:
                return validatorResult
            case .invalid(let validatorErrors):
                switch validatorResult {
                case .valid:
                    return .invalid(errors: validatorErrors)
                case .invalid(let validatorResultErrors):
                    return .invalid(errors: validatorResultErrors + validatorErrors)
                }
            }
        }
    }
}
/// Struct to facilitate working with validators
struct ValidatorConfigurator {
    /// composite of emptyTextStringValidator and textLengthValidator
    func nameValidator() -> Validator {
        return CompositeValidator(validators: emptyTextStringValidator(),
                                  textLengthValidator())
    }
    ///composite of emptyEmailStringValidator and EmailFormatValidator
    func emailValidator() -> Validator {
        return CompositeValidator(validators: emptyEmailStringValidator(),
                                  EmailFormatValidator())
    }
    /// composite of emptyPasswordStringValidator and passwordStrengthValidator
    func passwordValidator() -> Validator {
        return CompositeValidator(validators: emptyPasswordStringValidator(),
                                  passwordStrengthValidator())
    }
    
    func englishNameValidator() -> Validator {
        return CompositeValidator(validators: textLengthValidator(), englishNameValidator())
    }
    
    
    // Helper methods
    
    //Text
    private func emptyTextStringValidator() -> Validator {
        return EmptyStringValidator(invalidError: TextValidatorError.empty)
    }
    
    private func textLengthValidator() -> Validator {
        return StringLengthValidator(invalidError: TextValidatorError.tooShort, minLength:1)
    }
    
    private func nameEnglishValidator() -> Validator {
        return EmptyStringValidator(invalidError: TextValidatorError.notEnglish)
    }
    //Email
    private func emptyEmailStringValidator() -> Validator {
        return EmptyStringValidator(invalidError: EmailValidatorError.empty)
    }
    //Password
    private func emptyPasswordStringValidator() -> Validator {
        return EmptyStringValidator(invalidError: PasswordValidatorError.empty)
    }
    
    private func passwordStrengthValidator() -> Validator {
        return StringLengthValidator(invalidError: PasswordValidatorError.tooShort, minLength:5)
    }
    
}
