//
//  File.swift
//  Surfable
//
//  Created by Developer Silstone on 13/12/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import Foundation
import UIKit
import iProgressHUD
import TTGSnackbar

// MARK:PROTOCOL CLASS
public protocol ContentDynamicLayoutDelegate: class {
    func cellSize(indexPath: IndexPath) -> CGSize
}

extension UIViewController {
   
    func showSnackBarAlert(messageStr:String) {
        let snackbar = TTGSnackbar(
            message:messageStr,
            duration: .long,
            actionText: "Ok",
            actionBlock: { (snackbar) in
                snackbar.dismiss()
        }
        )
        snackbar.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        snackbar.animationType = .slideFromTopBackToTop
        snackbar.show()
    }
    //MARK: ALERT POP UP
    func PresentAlert(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.setValue(NSAttributedString(string:title, attributes: [NSAttributedString.Key.font : UIFont(name:"Krub-Bold", size: 20) as Any, NSAttributedString.Key.foregroundColor :hexStringToUIColor(hex: "#374785")]), forKey: "attributedTitle")
//         alertController.setValue(NSAttributedString(string:message, attributes: [NSAttributedString.Key.font : UIFont(name:"SegoeUI-Regular", size: 16) as Any, NSAttributedString.Key.foregroundColor :hexStringToUIColor(hex: "#003644")]), forKey: "attributedMessage")
//        let myString  = "Alert Title"
//        var myMutableString = NSMutableAttributedString()
//        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
//        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location:0,length:myString.characters.count))
//        alertController.setValue(myMutableString, forKey: "attributedTitle")
//        alertController.setValue(myMutableString, forKey: "attributedMessage")

        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
       // OKAction.setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
    //MARK:SETUP PROGRESS HUD
    func setupProgressHud(view:UIView) {
        let iprogress: iProgressHUD = iProgressHUD()
        iprogress.isShowModal = true
        iprogress.isShowCaption = true
        iprogress.isTouchDismiss = false
        iprogress.indicatorStyle = .circleStrokeSpin
        iprogress.boxColor = .clear
        iprogress.indicatorColor = hexStringToUIColor(hex: "#F04141")
        iprogress.indicatorSize = 20
        iprogress.alphaModal = 0.3  // Background
        // Attach iProgressHUD to views
        iprogress.attachProgress(toViews: view)

        // Show iProgressHUD directly from view
    }
}

extension UITextField {
    
    func addDoneButtonToKeyboard(myAction: Selector?, target: Any?) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        var done = UIBarButtonItem()
        if target == nil {
            done = UIBarButtonItem(title: "Done", style: .done, target: self, action: myAction)
        } else {
            done = UIBarButtonItem(title: "Done", style: .done, target: target!, action: myAction)
        }
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    // Say hi function in here!!!!
    
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    func getDateStringFromUTCWithFormat(Format:String) -> String {
            let date = Date(timeIntervalSince1970: self)
            let dateFormatter = DateFormatter()
            //dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = Format
            return dateFormatter.string(from:date)
        }
}

extension UILabel {

    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))


        self.attributedText = attributedString
    }
}

func GetDeviceType() -> String {
    var  DeviceType = ""
    if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            print("iPhone 5/5S/5C/SE")
            DeviceType = "iPhone 5/5S/5C/SE"
        case 1334:
            print("iPhone 6/6S/7/8")
            DeviceType = "iPhone 6/6S/7/8"
        case 1920, 2208:
            print("iPhone 6+/6S+/7+/8+")
            DeviceType = "iPhone 6+/6S+/7+/8+"
        case 2436:
            print("iPhone X, XS")
            DeviceType = "iPhone X, XS"
        case 2688:
            print("iPhone XS Max")
            DeviceType = "iPhone XS Max"
        case 1792:
            print("iPhone XR")
            DeviceType = "iPhone XR"
        default:
            DeviceType = "Unknown"
        }
    }
    return  DeviceType
}
//MARK: CHECK DIRECTION
func Get_Direction(Direction_in_Degree:Double) -> String {
    if Direction_in_Degree == 0{
        return "N"
    }else if Direction_in_Degree == 45{
        return "NE"
    }else if Direction_in_Degree == 90{
        return "E"
    }else if Direction_in_Degree == 135{
        return "SE"
    }else if Direction_in_Degree == 180{
        return "S"
    }else if Direction_in_Degree == 225{
        return "SW"
    }else if Direction_in_Degree == 270{
        return "W"
    }else if Direction_in_Degree == 315{
        return "NW"
    }else if  Direction_in_Degree > 0 &&  Direction_in_Degree < 45{
        return "NNE"
    }else if  Direction_in_Degree > 45 &&  Direction_in_Degree < 90{
        return "ENE"
    }else if  Direction_in_Degree > 90 &&  Direction_in_Degree < 135{
        return "ESE"
    }else if  Direction_in_Degree > 135 &&  Direction_in_Degree < 180{
        return "SSE"
    }else if  Direction_in_Degree > 180 &&  Direction_in_Degree < 225{
        return "SSW"
    }else if  Direction_in_Degree > 225 &&  Direction_in_Degree < 270{
        return "WSW"
    }else if  Direction_in_Degree > 270 && Direction_in_Degree < 315{
        return "WNW"
    }else{
        return "NNW"
    }
    
}
//MARK:ROTATE BY ANGLE
extension UIImage{
    func rotateBy(angle:Double,image:UIImageView)  {
        image.transform = image.transform.rotated(by: CGFloat(Double.pi/2))
    }
    
}
//MARK: DATE ADDITION SUBTRACTION
extension Date {
        func getDay() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"
            return dateFormatter.string(from: self)
        }
        func getMonth() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            return dateFormatter.string(from: self)
        }
        func getYear() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            return dateFormatter.string(from: self)
        }
        func getDateStringFromDate(Format:String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Format
            return dateFormatter.string(from: self)
        }
    /// Returns a Date with the specified amount of components added to the one it is called with
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        let components = DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds)
        return Calendar.current.date(byAdding: components, to: self)
    }
    
    /// Returns a Date with the specified amount of components subtracted from the one it is called with
    func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        return add(years: -years, months: -months, days: -days, hours: -hours, minutes: -minutes, seconds: -seconds)
    }
    
}
//MARK: VALIDATE EMAIL
func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}
//MARK: TOGGLE IMAGE FOR UIBUTTON
extension UIButton{
    func ToggleImageForUIButton(selected:String,Unselected:String,isSelected:Bool){
        if isSelected{
            setImage(UIImage(named:selected), for: .normal)
        }else{
            setImage(UIImage(named: Unselected), for: .normal)
        }
    }
    func isAlertActiveFor(value:Bool){
        if value == true{
            setBackgroundImage(UIImage(named:"checkboxchecked"), for: .normal)
        }else{
            setBackgroundImage(UIImage(named:"checkboxempty"), for: .normal)
        }
    }
}
//MARK: TOGGLE IMAGE FOR UIIMAGE
extension UIImageView{
    func ToggleImageForUIImage(selected:String,Unselected:String,isSelected:Bool){
        if isSelected{
            image = UIImage(named: selected)
        }else{
            image = UIImage(named: Unselected)
        }
    }
}
//MARK: TOGGLE IMAGE FOR Bool Value
extension UIImageView{
    func isAlertActiveImg(value:Bool){
        if value == true{
            image = UIImage(named: "alertactive")
        }else{
            image = UIImage(named: "alertnotactive")
        }
    }
   
}
func checkCharacterMinimumLength(textField: UITextField) -> Bool {
    if textField.text!.count < 3{
 
        return false
    }else{
       
        return true
    }
    
}


func checkMaxLength(textField: UITextField!, maxLength: Int) {
    if (textField.text!.count > maxLength) {
        textField.deleteBackward()
    }
}
func CheckIfStringContainSpace(string: String) -> Bool {
    return string.rangeOfCharacter(from: CharacterSet.whitespaces) == nil
}

//MARK:STRING TO DATE
   public func StringToDate( dateString: String)-> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        //according to date format your date string
        guard let date = dateFormatter.date(from: dateString) else {
            fatalError()
        }
        
        return date
        
    }

//MARK:CORNER READIUS AND BORDER WIDTH
extension UIView {
    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
extension UIView {
    public func CornerRadius(_ cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }

     func BorderWith(Width:CGFloat,color:UIColor) {
        layer.borderWidth = Width
        layer.borderColor = color.cgColor
    }
}
//MARK: NAVIGATION OF VIEWCONTROLLER
public func PushTo(FromVC:UIViewController,ToStoryboardID:String){
    let mstoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController: UIViewController = mstoryboard.instantiateViewController(withIdentifier: ToStoryboardID)
    FromVC.navigationController?.pushViewController(viewController, animated: true)
}
public func PresentTo(FromVC:UIViewController,ToStoryboardID:String){
    let mstoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController: UIViewController = mstoryboard.instantiateViewController(withIdentifier: ToStoryboardID)
    FromVC.present(viewController, animated: true, completion: nil)
}

  public  func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
class RoundedButtonWithShadow: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height/2
        self.layer.shadowColor = hexStringToUIColor(hex: "#000000").cgColor//UIColor.black.cgColor
      //  self.layer.shadowPath = UIBezierPath(roundedRect:bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        self.layer.shadowOpacity = 0.37
        self.layer.shadowRadius = 4.0
    }
}
extension UIView {
    func roundSpecificCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
    }
    //someView.round(corners: [.topLeft, .topRight], radius: 5)
}
extension UIView {
    func dropShadowSurfable(){
        layer.shadowColor = hexStringToUIColor(hex: "#000000").cgColor
        layer.shadowOpacity = 0.37
        layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        layer.shadowRadius = 4.0
        layer.masksToBounds = false
        
    }
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = hexStringToUIColor(hex: "#000000").cgColor
        layer.shadowOpacity = 0.36
        layer.shadowOffset = CGSize(width:0, height:0)
        layer.shadowRadius = 3
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.33, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

//MARK: DATE EXTENSION
extension Date {
    
    var timeAgoSinceNow: String {
        return getTimeAgoSinceNow()
    }
    
    private func getTimeAgoSinceNow() -> String {
        
        var interval = Calendar.current.dateComponents([.year], from: self, to: Date()).year!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " year" : "\(interval)" + " years"
        }
        
        interval = Calendar.current.dateComponents([.month], from: self, to: Date()).month!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " month" : "\(interval)" + " months"
        }
        
        interval = Calendar.current.dateComponents([.day], from: self, to: Date()).day!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " day" : "\(interval)" + " days"
        }
        
        interval = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " hour" : "\(interval)" + " hours"
        }
        
        interval = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " minute" : "\(interval)" + " minutes"
        }
        
        return "a moment ago"
    }
}


extension UIView {

    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidthV: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColorV: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable
       var shadowRadius: CGFloat {
           get {
               return layer.shadowRadius
           }
           set {

               layer.shadowRadius = newValue
           }
       }
       @IBInspectable
       var shadowOffset : CGSize{

           get{
               return layer.shadowOffset
           }set{

               layer.shadowOffset = newValue
           }
       }
       @IBInspectable
       var shadowMask : Bool{

           get{
               return layer.masksToBounds
           }set{

               layer.masksToBounds = newValue
           }
       }
       @IBInspectable
       var shadowColor : UIColor{
           get{
               return UIColor.init(cgColor: layer.shadowColor!)
           }
           set {
               layer.shadowColor = newValue.cgColor
           }
       }
       @IBInspectable
       var shadowOpacity : Float {

           get{
               return layer.shadowOpacity
           }
           set {

               layer.shadowOpacity = newValue

           }
       }    
}
extension UIPageControl {
    
    func customPageControl() {
        for (pageIndex, dotView) in self.subviews.enumerated() {
            if self.currentPage == pageIndex {
                dotView.backgroundColor = UIColor(red: 247, green: 108, blue: 108, alpha: 1)
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
                dotView.layer.borderColor = UIColor(red: 55, green: 71, blue: 133, alpha: 1).cgColor
                dotView.layer.borderWidth = 1
            }else{
                dotView.backgroundColor = .clear
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
                dotView.layer.borderColor = UIColor(red: 55, green: 71, blue: 133, alpha: 1).cgColor
                dotView.layer.borderWidth = 1
            }
        }
    }
    
}
extension UIImage {
    
    /// Creates a circular outline image.
    class func outlinedEllipse(size: CGSize, color: UIColor, lineWidth: CGFloat = 1.0) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWidth)
        // Inset the rect to account for the fact that strokes are
        // centred on the bounds of the shape.
        let rect = CGRect(origin: .zero, size: size).insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
        context.addEllipse(in: rect)
        context.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
