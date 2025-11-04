//
//  VerifyOtpCodeVC.swift
//  RHYME
//
//  Created by Silstone on 08/10/21.
//

import UIKit
import iProgressHUD
import Alamofire

class VerifyOtpCodeVC: UIViewController {

    @IBOutlet weak var otpFirstField: UITextField!
    @IBOutlet weak var otpSecondField: UITextField!
    @IBOutlet weak var otpThirdField: UITextField!
    @IBOutlet weak var otpFourthField: UITextField!
    @IBOutlet weak var otpFifthField: UITextField!
    @IBOutlet weak var otpSixthField: UITextField!
    @IBOutlet weak var phoneNumberLable: UILabel!
    var netwoking = NetworkApi()
    var otpStr:Int32?
    var phoneNumber:String?
    @IBOutlet weak var timerLable: UILabel!
    @IBOutlet weak var resendOtpBtn: UIButton!
    var seconds = 30 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        phoneNumberLable.text = "Sent via SMS to \(phoneNumber ?? "+1987-654-3210")"
        setupProgressHud(view: view)
        // Do any additional setup after loading the view.
        //self.showSnackBarAlert(messageStr: "Please enter your otp is \(otpStr ?? 567889)")
        //fillotp()
        runTimer()
    }
    func fillotp()  {
        var otpArr = [Int32]()
        var otpStr2 = otpStr
        while otpStr2! > 0 {
            otpArr.append(otpStr2! % 10)
            otpStr2 = otpStr2! / 10
        }
        otpArr.reverse()
        print(otpArr)
        otpFirstField.text = "\(otpArr[0])"
        otpSecondField.text = "\(otpArr[1])"
        otpThirdField.text = "\(otpArr[2])"
        otpFourthField.text = "\(otpArr[3])"
        otpFifthField.text = "\(otpArr[4])"
        otpSixthField.text = "\(otpArr[5])"
    }
    
    func runTimer() {
         timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(VerifyOtpCodeVC.updateTimer)), userInfo: nil, repeats: true)
    }
    @objc func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
        self.timerLable.text = "Resend OTP in 00:\(seconds)" //This will update the label.
        if seconds == 0 {
            resetTimer()
        }
    }
    
    func resetTimer()  {
        timer.invalidate()
        seconds = 30    //Here we manually enter the restarting point for the seconds, but it would be wiser to make this a variable or constant.
        //self.timerLable.text = "Resend OTP in 00:30"
        self.timerLable.text = ""
        resendOtpBtn.isHidden = false
    }
    
//    func timeString(time:TimeInterval) -> String {
//    let seconds = Int(time) % 30
//    return String(format:"Resend OTP in 00:%02i",seconds)
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - Api methods
    func verifyOTP() {
        view.showProgress()
        let header: HTTPHeaders = [
            "Authorization" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        let parameters: [String: Any] = ["phone_number" : phoneNumber!,"otp" : otpStr!]
        
        
        netwoking.UnivarsalPostApi(headers: header, apiMethod: kverifyOTP, params: parameters) { (response) in
            print(kverifyOTP)
            print(parameters)
            self.view.dismissProgress()
            switch response.result {
                
            case .success(_):
                
                
                
                print(response.result.value as Any)
                
                if let dic =  response.result.value as? [String : Any]{
                    
                    if (dic["code"] as! Int == 200) {
                        if let responsedic =  dic["data"] as? [String : Any] {
                            print(responsedic)
                            _APP_MANAGER.saveAuthorizationToken(responsedic["access_token"] as! String)
                            _APP_MANAGER.setUserLogin(state: true)
                            let userinfo = responsedic.nullKeyRemoval()
                            _APP_MANAGER.saveUserInfo(userinfo as NSDictionary)
                            
                            if let documentArray = responsedic["document"] as? [NSDictionary] {
                                if documentArray.count > 0 {
                                    PushTo(FromVC: self, ToStoryboardID: "CustomTabBarController")
                                }else{
                                    PushTo(FromVC: self, ToStoryboardID: "CompleteProfileVC")
                                }
                            }else{
                                PushTo(FromVC: self, ToStoryboardID: "CompleteProfileVC")
                            }
                           
    
                        }
                        
                    }else if (dic["code"] as! Int == 400){
                        let message = dic["message"] as? String
                        //showSnackBarAlert(messageStr: message ?? "user deactivated by admin")
                        AppLaunch.showAlertView(title: "Alert!", message: message ?? "user deactivated by admin")
                    }
                }  else {
                    
                    
                }
                
                
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    
    func sendOTP() {
        view.showProgress()
        let header: HTTPHeaders = [
            //            "Username": "sdsol",
            //            "Password": "sdsol99",
            "Authorization" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        //let parameters: [String: Any] = ["phone_number" : "97297966962"]
        let parameters: [String: Any] = ["phone_number" : phoneNumber!]
        
        
        netwoking.UnivarsalPostApi(headers: header, apiMethod: ksendOTP, params: parameters) { (response) in
            print(ksendOTP)
            print(parameters)
            self.view.dismissProgress()
            switch response.result {
                
            case .success(_):
                
                
                
                print(response.result.value as Any)
                
                if let dic =  response.result.value as? [String : Any]{
                    
                    if (dic["code"] as! Int == 200) {
                        if let responsedic =  dic["data"] as? [String : Any] {
                            print(responsedic)
                            //PushTo(FromVC: self, ToStoryboardID: "VerifyOtpCodeVC")
                            self.otpStr = responsedic["otp"] as? Int32
                        }
                        
                    }else{
                        self.showSnackBarAlert(messageStr: "user is not registered with this contact number")
                    }
                }  else {
                    
                    
                    
                }
                
                
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    @IBAction func verifyCodeAction(_ sender: UIButton) {
        
        if otpFirstField.text?.count == 0 || otpSecondField.text?.count == 0 || otpThirdField.text?.count == 0 || otpFourthField.text?.count == 0 || otpFifthField.text?.count == 0 || otpSixthField.text?.count == 0 {
            self.showSnackBarAlert(messageStr: "Please enter your code")
        }else{
            //PushTo(FromVC: self, ToStoryboardID: "CompleteProfileVC")
            let CombinedOtp1 = self.otpFirstField.text! + self.otpSecondField.text! + self.otpThirdField.text!
            let CombinedOtp2 = self.otpFourthField.text! + self.otpFifthField.text! + self.otpSixthField.text!
            let verfiedOtp = CombinedOtp1 + CombinedOtp2
            
            if verfiedOtp != "\(String(describing: otpStr!))"  {
                self.otpFirstField.text = ""
                self.otpSecondField.text = ""
                self.otpThirdField.text = ""
                self.otpFourthField.text = ""
                self.otpFifthField.text = ""
                self.otpSixthField.text = ""
                self.showSnackBarAlert(messageStr: "You have entered Wrong OTP")
            }else{
                verifyOTP()
            }
           

            
        }
        
    }
    @IBAction func resendOtpAction(_ sender: UIButton) {
        sendOTP()
        runTimer()
        resendOtpBtn.isHidden = true
    }
    


}

//MARK: UITextFieldDelegate methods
extension VerifyOtpCodeVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if ((textField.text?.count)! < 1) && (string.count > 0) {
            if textField == otpFirstField {
                otpSecondField.becomeFirstResponder()
            }
            if textField == otpSecondField{
                otpThirdField.becomeFirstResponder()
            }
            if textField == otpThirdField{
                otpFourthField.becomeFirstResponder()
            }
            if textField == otpFourthField{
                otpFifthField.becomeFirstResponder()
            }
            if textField == otpFifthField{
                otpSixthField.becomeFirstResponder()
            }
            if textField == otpSixthField{
                textField.text = string
                otpSixthField.resignFirstResponder()
            } else {
                textField.text = string
            }
            //auto move to next page
//            if self.getOtpCode().count == 6 {
//                self.view.endEditing(true)
//                self.verifyOTP(code: self.getOtpCode())
//            }
            
            return false
        } else if ((textField.text?.count)! >= 1) && (string.count == 0){
            if textField == otpFirstField{
                otpFirstField.becomeFirstResponder()
            }
            if textField == otpSecondField {
                otpFirstField.becomeFirstResponder()
            }
            if textField == otpThirdField {
                otpSecondField.becomeFirstResponder()
            }
            if textField == otpFourthField {
                otpThirdField.becomeFirstResponder()
            }
            if textField == otpFifthField{
                otpFourthField.becomeFirstResponder()
            }
            if textField == otpSixthField{
                otpFifthField.becomeFirstResponder()
            }
            textField.text = ""
            return false
        }
        else if (textField.text?.count)! >= 1 {
            textField.text = string
            return false
        }
        
        return true
    }
}
