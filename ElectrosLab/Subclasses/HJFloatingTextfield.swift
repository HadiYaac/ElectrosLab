//
//  HJFloatingTextfield.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 27/11/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import Foundation


import UIKit

class HJFloatingLabelTextField: UITextField {
    
    private enum AnimationType {
        case showFloatingLabel, hideFloatingLabel
    }
    /// Detail label appears under textfield
    var detailsLabel: UILabel?
    /// Label holding UITextfields placeholder and floats above textfield
    var floatingLabel: UILabel?
    /// Floating label font
    var floatingLabelFont: UIFont? {
        didSet {
            floatingLabel?.font = floatingLabelFont
            floatingLabel?.sizeToFit()
        }
    }
    /// Floating label color when inactive
    var floatingLabelPassiveColor: UIColor?
    /// Floating label color when active
    var floatingLabelActiveColor: UIColor?
    /// Floating label animation duration when showing
    var floatingLabelShowAnimationDuration: CGFloat? = 0.5
    /// Floating label animation duration when hiding
    var floatingLabelHideAnimationDuration: CGFloat? = 0
    /// Amount of padding added to the left/right of textfield
    var horizontalPadding: CGFloat? = 0.0
    
    var rightMargin: CGFloat = 0.0
    
    private var storedText: String = String()
    private var xOrigin: CGFloat?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    public func clearDetailsLabel() {
        detailsLabel?.text = ""
        detailsLabel?.isHidden = true
    }
    
    public func setDetailsText(text: String) {
        detailsLabel?.isHidden = false
        detailsLabel?.text = text
        //        detailsLabel?.sizeToFit()
    }
    
    public func setDetailsLabelColor(color: UIColor?) {
        detailsLabel?.textColor = color
    }
    
    public func shouldAddDetailsLabel(_ shouldAdd : Bool) {
        detailsLabel?.isHidden = !shouldAdd
    }
    
    public func prepareDetailsLabel(defaultText: String?, onErrorColor: UIColor?, defaultColor: UIColor?) {
        detailsLabel?.isHidden = false
        if let defaultText = defaultText {
            setDetailsText(text: defaultText)
        }
        if let defaultColor = defaultColor {
            detailsLabel?.textColor = defaultColor
        }
    }
    
    private func setup() {
        setupTextField()
        setupFloatLabel()
        setupDetailLabel()
    }
    
    private func setupTextField() {
        self.textAlignment = .left
        self.clipsToBounds = true
        self.borderStyle = .none
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clearButtonMode = .never
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(notification:)), name: Notification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    private func setupFloatLabel() {
        floatingLabel = UILabel()
        floatingLabel?.textColor = UIColor.black
        floatingLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        floatingLabel?.alpha = 0.0
        floatingLabel?.center = CGPoint.init(x: xOrigin!, y: 0)
        floatingLabel?.translatesAutoresizingMaskIntoConstraints = true
        addSubview(floatingLabel!)
        
        floatingLabelActiveColor = UIColor.lightGray
        floatingLabelPassiveColor = UIColor.lightGray
        
    }
    
    private func setupDetailLabel() {
        detailsLabel = UILabel()
        detailsLabel?.isHidden = true
        detailsLabel?.textColor = UIColor.lightGray
        detailsLabel?.font = UIFont.systemFont(ofSize: 13)
        detailsLabel?.alpha = 1.0
        detailsLabel?.numberOfLines = 0
        let frame = CGRect(x: 0, y: self.frame.height + 5, width: self.frame.width, height: 15)
        detailsLabel?.frame = frame
        addSubview(detailsLabel!)
    }
    
    private func toggleFloatLabel(animationType: AnimationType) {
        self.placeholder = (animationType == .showFloatingLabel) ? "" : floatingLabel?.text
        floatingLabel?.textAlignment = self.textAlignment
        
        let easingOptions: UIViewAnimationOptions = (animationType == .showFloatingLabel) ? .curveEaseOut : .curveEaseIn
        let duration = (animationType == .showFloatingLabel) ? floatingLabelShowAnimationDuration : floatingLabelHideAnimationDuration
        
        let animationBlock: (() -> Void) = {
            self.toggleFloatLabelProperties(animationType: animationType)
        }
        
        UIView.animate(withDuration: Double(duration!), delay: 0.0, options: [.beginFromCurrentState, easingOptions], animations: animationBlock, completion: nil)
    }
    
    var floatLabelInsets: UIEdgeInsets {
        let top: CGFloat = self.text!.count > 0 ? 5.0 : 0.0
        return UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
    }
    
    @objc func textDidChange(notification: Notification) {
        if notification.object as? HJFloatingLabelTextField === self {
            if self.text!.count > 0 {
                storedText = self.text!
                if floatingLabel!.alpha > 0 {
                    self.toggleFloatLabel(animationType: .showFloatingLabel)
                }
            } else {
                if floatingLabel!.alpha > 0 {
                    self.toggleFloatLabel(animationType: .hideFloatingLabel)
                }
                storedText = ""
            }
        }
    }
    
    
    private func toggleFloatLabelProperties(animationType: AnimationType) {
        switch animationType {
        case .showFloatingLabel:
            self.floatingLabel?.alpha = 1.0
        default:
            if let count = self.text?.count {
                if count > 0 {
                    floatingLabel?.alpha = 1.0
                } else {
                    floatingLabel?.alpha = 0.0
                }
            }
        }
        
        let yOrigin: CGFloat = -7
        floatingLabel?.frame = CGRect(x: xOrigin!, y: yOrigin, width: (floatingLabel?.frame.width)!, height: (floatingLabel?.frame.height)!)
    }
    
    override var text: String? {
        didSet {
            
            if text!.count > 0 && storedText.isEmpty  {
                self.toggleFloatLabelProperties(animationType: .showFloatingLabel)
                floatingLabel?.textColor = floatingLabelPassiveColor
            }
        }
    }
    
    override var placeholder: String? {
        didSet {
            if self.placeholder!.count > 0 {
                floatingLabel?.text = self.placeholder
            }
            floatingLabel?.sizeToFit()
        }
    }
    
    override var textAlignment: NSTextAlignment {
        didSet {
            switch textAlignment {
            case .right:
                xOrigin = self.frame.width - (floatingLabel?.frame.width)! - horizontalPadding!
            case .center:
                xOrigin = (self.frame.width / 2.0) - ((floatingLabel?.frame.width)! / 2.0)
            default:
                xOrigin = horizontalPadding
            }
        }
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds)
        var newBounds = bounds
        let scaledMargin = rightMargin * UIScreen.main.scale
        newBounds.size.width = newBounds.size.width - scaledMargin
        return newBounds.insetBy(dx: 0, dy: 5)
        //return UIEdgeInsetsInsetRect(super.textRect(forBounds: bounds), self.floatLabelInsets)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.editingRect(forBounds: bounds)
        var newBounds = bounds
        let scaledMargin = rightMargin * UIScreen.main.scale
        newBounds.size.width = newBounds.size.width - scaledMargin
        return newBounds.insetBy(dx: 0, dy: 5)
        // return UIEdgeInsetsInsetRect(super.editingRect(forBounds: bounds), self.floatLabelInsets)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (!self.isFirstResponder && self.text!.count > 0) {
            self.toggleFloatLabelProperties(animationType: .hideFloatingLabel)
        } else if (self.text!.count > 0) {
            self.toggleFloatLabelProperties(animationType: .showFloatingLabel)
        }
    }
    
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        if (super.becomeFirstResponder()) {
            floatingLabel?.textColor = floatingLabelActiveColor
            storedText = self.text!
            return true
        } else {
            return false
        }
    }
    @discardableResult
    override func resignFirstResponder() -> Bool {
        if (self.canResignFirstResponder) {
            if let count = floatingLabel?.text?.count {
                if count > 0 {
                    floatingLabel?.textColor = floatingLabelPassiveColor
                }
            }
            super.resignFirstResponder()
            return true
        } else {
            return false
        }
    }
}
