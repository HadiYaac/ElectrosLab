//
//  Extensions.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 27/11/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import Foundation
//
//  Extensions.swift
//  Trellis
//
//  Created by Ibrahim Kteish on 3/22/17.
//  Copyright © 2017 Ibrahim Kteish. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import SVProgressHUD

///Logs if #DEBUG Key in project settings is set to true
///
///- Parameter items:Zero or more items to print.
func printD(_ items: Any ...) {
    
    #if DEBUG
        print(items)
    #endif
}

extension Dictionary {
    
    ///Switch the value's key to with another key if the value exists
    ///
    ///- Parameter key: The key to replace.
    ///- Parameter toKey: The key to be replaced by
    private mutating func switchValue(forKey key: Key, toKey: Key) {
        if let entry = self.removeValue(forKey: key) {
            self[toKey] = entry
        }
    }
    
    ///Switch the value's key to with another key if the value exists
    ///
    ///- Parameter key: The key to replace.
    ///- Parameter toKey: The key to be replaced by
    func switchedValue(forKey key: Key, toKey: Key) -> Dictionary {
        var copy = self
        copy.switchValue(forKey: key, toKey: toKey)
        return copy
    }
}

extension UIView {
    
    /// Init a view for autolayout usage
    ///
    /// - Parameter superview: the superview you want to add the initiated view to it.
    /// - Returns: the initiated view
    class func autoLayoutView(in superview: UIView? = nil) -> Self {
        let view = self.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            superview.addSubview(view)
        }
        return view
    }
    /// fill a subview in its superview
    func fillInsideSuperView() {
        
        if let superview = self.superview {
            
            let views = ["self": self]
            let horzConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[self]|", options: [], metrics: nil, views: views)
            superview.addConstraints(horzConstraints)
            let vertConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[self]|", options: [], metrics: nil, views: views)
            superview.addConstraints(vertConstraints)
            
        } else {
            
            assertionFailure("\(self) doesn't belong to a superview")
        }
    }
}
/// this extention expose so UIView properties to be seen in the Interfacebuilder
@IBDesignable extension UIView {
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = (newValue ?? UIColor.clear).cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            } else {
                return nil
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}

extension UIView {
    /// Apply a mask with specific rect to a view
    ///
    /// - Parameter rect: the rect you want to apply the mask on it
    /// - Parameter cornerRadius: corner radius of the rect
    /// - Parameter inverse: if true it Specifies the even-odd winding rule.
    func mask(withRect rect: CGRect, cornerRadius: CGFloat = 10, inverse: Bool = false) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        self.mask(withPath: path, inverse: inverse)
    }
    
    /// Apply a mask with specific path to a view
    ///
    /// - Parameter path: the path of the mask
    /// - Parameter inverse: if true it Specifies the even-odd winding rule.
    func mask(withPath path: UIBezierPath, inverse: Bool = false) {
        let path = path
        let maskLayer = CAShapeLayer()
        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = kCAFillRuleEvenOdd
        }
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    func hideKeyboardOnTouch() {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(hideKeyboard))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        self.endEditing(true)
    }
    
}

//MARK :  UINib
extension UINib {
    /// Returns a UINib object initialized to the nib file in the default bundle.
    /// The UINib object looks for the nib file in the bundle's language-specific project directories first, followed by the Resources directory.
    /// - Parameter nibName: The name of the nib file, without any leading path information.
    /// - Returns: The initialized UINib object. An exception is thrown if there were errors during initialization or the nib file could not be located.
    convenience init(nibName: String) {
        self.init(nibName: nibName, bundle: nil)
    }
    /// Make Generic view form nib file
    ///
    /// - Parameter nibName: The name of the nib file, without any leading path information.
    /// - Parameter type: the class of the view.
    /// - Returns: An object containing the top-level object from the nib file.
    static func viewFromNibName<T: UIView>(_ nibName: String, type: T.Type) -> T {
        
        let nibWithName = UINib(nibName: nibName)
        let nibElements = nibWithName.instantiate(withOwner: nil, options: nil)
        let view = nibElements[0] as! T
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

extension UIColor {
    /// Create a UIColor object form hex
    /// - Parameter rgb: rgb hex value.
    /// - Parameter alpha: The opacity value of the color object, specified as a value from 0.0 to 1.0. Alpha values below 0.0 are interpreted as 0.0, and values above 1.0 are interpreted as 1.0.
    /// - Returns: An UIColor object.
    class func color(withHexValue rgb: Int, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16))/255.0, green:((CGFloat)((rgb & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(rgb & 0xFF))/255.0, alpha: alpha)
    }
    /// Create a UIColor object form AppColorHex Enum value
    /// - Parameter value: value of AppColorHex.
    /// - Parameter alpha: The opacity value of the color object, specified as a value from 0.0 to 1.0. Alpha values below 0.0 are interpreted as 0.0, and values above 1.0 are interpreted as 1.0.
    /// - Returns: An UIColor object.
    public class func color(withHexValue value: AppColorHex, alpha: CGFloat = 1.0) -> UIColor {
        return .color(withHexValue: value.rawValue, alpha:alpha)
    }
}

/// Returns the name of the nib file as `String` from the name of the class (note : nib file and its associated class must have same names)
protocol NibLoadableView: class { }
extension NibLoadableView where Self: UIView {
    
    static var NibName: String {
        return String(describing: self)
    }
}
/// Retuns a `String` as a reusable identifier of any view (again using the class name as ID)
protocol ReusableView: class {}
extension ReusableView where Self: UIView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
//With above protocols in place, we can use Swift Generics and extend UITableView/UICollectionView to simplify cell registration and dequeuing.
/// UITableView conformance
extension UITableViewCell: NibLoadableView, ReusableView {}

extension UITableView {
    
    func register<T: UITableViewCell>(_: T.Type) {
        let Nib = UINib(nibName: T.NibName)
        self.register(Nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
}

extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

extension UICollectionReusableView : NibLoadableView, ReusableView {}

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_: T.Type) {
        let nib = UINib(nibName: T.NibName)
        self.register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerSupplementary<S: UICollectionReusableView>(_: S.Type) {
        
        let nib = UINib(nibName: S.NibName)
        self.register(nib, forSupplementaryViewOfKind: S.reuseIdentifier, withReuseIdentifier: S.reuseIdentifier)
    }
}

extension UICollectionView {
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
    
    func dequeueSupplementary<T: UICollectionReusableView>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableSupplementaryView(ofKind: T.reuseIdentifier, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

extension Float {
    /// Return a string representation of the float value
    var string: String {
        return "\(self)"
    }
    
    var toInt: Int {
        return Int(self)
    }
}

extension Int {
    /// Return a Float representation of the Int value
    var toFloat: Float {
        return Float(self)
    }
    /// Return a string representation of the Int value
    var string: String {
        return "\(self)"
    }
}

// Helper methods to deal with Float type formatting plz check TrellisNumberFormatter
extension Float {
    
    var scoreFormat: String {
        let formatted = TrellisNumberFormatter.formatScore(Double(self))
        return formatted
    }
    
    var scoreFormatFloat: Double {
        let unformatted =  TrellisNumberFormatter.unformat(string: scoreFormat) ?? 0
        return unformatted
    }
    
    var percentageFormatFloat: Double {
        let unformatted =  TrellisNumberFormatter.unformat(string: percentageFormat) ?? 0
        return unformatted
    }
    
    var percentageFormat: String {
        let formatted = TrellisNumberFormatter.formatPercentage(Double(self))
        return formatted
    }
    
    var formatUsingAbbreviation: String {
        let formatted = TrellisNumberFormatter.formatNumber(Double(self))
        return formatted
    }
    
    var numberFormatUsingAbbreviation: Double {
        let unformatted = TrellisNumberFormatter.unformat(string: formatUsingAbbreviation)
        return unformatted ?? 0
    }
    
    var averageFormatUsingAbbreviation: String {
        let formatted = TrellisNumberFormatter.formatFractionedNumber(Double(self))
        return formatted
        
    }
    
}


extension Array {
    /// Returns the first specified number of elements in a new array
    ///
    /// - Parameter elementCount: number of element you want to trim
    /// - Returns: New array containt the desired elementCount elements
    func takeElements(_ elementCount: Int) -> Array {
        var elements = elementCount
        if elementCount > count {
            elements = count
        }
        return Array(self[0..<elements])
    }
}

// MARK: UIViewController
extension UIViewController {
    
    /// Add child view controller to the self controller
    ///
    /// - Parameter child: the child view controller
    /// - Parameter metrics: Autolayout metrics for top margin only
    func TRSAddChildViewController(_ child: UIViewController, metrics: [String:Any] = ["topMargin": 29+8+8]) { // 29 = SegmentControl height, 8 = Margin
        
        child.willMove(toParentViewController: self)
        addChildViewController(child)
        child.beginAppearanceTransition(true, animated: true)
        view.addSubview(child.view)
        child.endAppearanceTransition()
        child.view.translatesAutoresizingMaskIntoConstraints = false
        let topGuide = self.topLayoutGuide
        
        let viewsDictionary: [String:Any] = ["child": child.view!, "topGuide": topGuide]
        
        let child_constraint_H: Array = NSLayoutConstraint.constraints(withVisualFormat: "H:|[child]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: viewsDictionary)
        let child_constraint_V: Array = NSLayoutConstraint.constraints(withVisualFormat: "V:[topGuide]-(topMargin)-[child]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: viewsDictionary)
        
        view.addConstraints(child_constraint_H)
        view.addConstraints(child_constraint_V)
        
        child.didMove(toParentViewController: self)
        
    }
    /// Remove child view controller from the self controller
    ///
    /// - Parameter child: the child view controller
    func TRSRemoveChildViewController(_ child: UIViewController) {
        
        child.willMove(toParentViewController: nil)
        child.beginAppearanceTransition(false, animated: true)
        child.view.removeFromSuperview()
        child.endAppearanceTransition()
        child.removeFromParentViewController()
        child.didMove(toParentViewController: nil)
    }
}

extension UITextField {
    public func addBottomBorder(width: CGFloat = 2.0, color: UIColor = UIColor.black) {
        borderStyle = .none
        self.layer.sublayers?.forEach({ (layer) in
            if layer.value(forKey: "name") != nil {
                layer.removeFromSuperlayer()
            }
        })
        if borderStyle == .none {
            let border = CALayer.init()
            border.setValue("border", forKey: "name")
            border.borderColor = color.cgColor
            border.backgroundColor = color.cgColor
            border.frame = CGRect.init(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
            border.borderWidth = width
            layer.addSublayer(border)
            layer.masksToBounds = true
        }
    }
    
    public func setupBottomBorder() {
        subviews.forEach { (subview) in
            if subview.tag == 347 {
                subview.removeFromSuperview()
            }
        }
        let view = UIView()
        view.tag = 347
        view.backgroundColor = .lightGray
        view.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1)
        self.addSubview(view)
    }
}

extension UIAlertController {
    public convenience init(title: String, message: String? = nil, defaultActionButtonTitle: String = "OK", tintColor: UIColor? = nil) {
        self.init(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: defaultActionButtonTitle, style: .default, handler: nil)
        addAction(defaultAction)
        if let color = tintColor {
            view.tintColor = color
        }
    }
    
    static func showAlert(with title: String, message: String, defaultActionButtonTitle: String = "Ok") {
        let alert = UIAlertController.init(title: title, message: message, defaultActionButtonTitle: defaultActionButtonTitle, tintColor: nil)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    static func showAlert(with title: String?, message: String, okayButtonTitle: String, okayButtonCallback: (() -> Void)?, cancelButtonTitle: String?, cancelButtonCallBack: (() -> Void)?) {
        let alert = UIAlertController.init(title: title ?? "", message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: okayButtonTitle, style: .default) { (action) in
            okayButtonCallback?()
        }
        let cancelAction = UIAlertAction(title: cancelButtonTitle ?? "", style: .cancel) { action in
            cancelButtonCallBack?()
        }
        if cancelAction.title != nil && cancelAction.title! != "" {
            alert.addAction(cancelAction)
        }
        alert.addAction(okayAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}

extension UIImageView {
    
    func downloadImage(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, completion: @escaping ((UIImage?) -> ())) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200, let mimeType = response?.mimeType, mimeType.hasPrefix("image"), let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
            }.resume()
    }
    
    func makeCircular() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
    }
}

extension String {
    var isNumeric: Bool {
        if self.count > 0 {
            let numbers: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
            return Set(self).isSubset(of: numbers)
        }
        return false
    }
}

extension WKWebsiteDataStore {
    static func removeCache() {
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeCookies])
        let date = NSDate(timeIntervalSince1970: 0)
        self.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler:{ })
    }
}

extension SVProgressHUD {
    class func showLoader() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.setBackgroundColor(UIColor.init(red: 0.97, green: 0.97, blue: 0.97, alpha: 1))
        self.setForegroundColor(UIColor.blue)
        self.setDefaultMaskType(.clear)
        self.setRingRadius(4)
        self.setContainerView(UIApplication.shared.keyWindow?.rootViewController?.view)
        self.show()
    }
    
    class func dismissLoader() {
        UIApplication.shared.endIgnoringInteractionEvents()
        self.dismiss()
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

import RxSwift
import RxCocoa
extension Reactive where Base: UIButton {
    public var isEnabled: Binder<Bool> {
        return Binder(self.base) { button, value in
            button.alpha = value ? 1.0 : 0.5
            button.isEnabled = value
        }
    }
}



extension UIViewController {
    
    ///Returns a view controller from the provided storyboard using its identifier
    /// - Parameter storyboard: Storyboard containing the view controller
    /// - Parameter identifier: The associated VC identifier
    ///
    /// - Returns: A view controller of the provided generic type T
    private class func instantiateController<T: UIViewController>(inStoryboard storyboard: UIStoryboard, identifier: String) -> T {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    ///Class func Returns a view controller from the provided storyboard using its identifier
    /// - Parameter storyboard: Storyboard containing the view controller
    /// - Parameter identifier: The associated VC identifier
    ///
    /// - Returns: A view controller with thw same caller type
    class func controllerInStoryboard(_ storyboard: UIStoryboard, identifier: String) -> Self {
        return instantiateController(inStoryboard: storyboard, identifier: identifier)
    }
    
    ///Class func Returns a view controller from the provided storyboard using the class name
    /// - Parameter storyboard: Storyboard containing the view controller
    ///
    /// - Returns: A view controller with thw same caller type
    class func controllerInStoryboard(_ storyboard: UIStoryboard) -> Self {
        return controllerInStoryboard(storyboard, identifier: nameOfClass)
    }
    ///Class func Returns a view controller from the provided storyboard using the class name
    /// - Parameter storyboard: Storyboard enum containing the view controller
    ///
    /// - Returns: A view controller with thw same caller type
    class func controllerInStoryboard(_ storyboard: StoryBoards) -> Self {
        return controllerInStoryboard(UIStoryboard(name: storyboard.rawValue, bundle:nil), identifier: nameOfClass)
    }
}

extension NSObject {
    ///Returns the name of a class as a string.
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
