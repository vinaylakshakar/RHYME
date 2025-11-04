//
//  LoginVC.swift
//  RHYME
//
//  Created by Silstone on 05/10/21.
//

import UIKit
import iProgressHUD
import Alamofire

class LoginVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var countryCodeField: UITextField!
    var netwoking = NetworkApi()
    var CountryArray = [NSDictionary]()
    let pickerView = UIPickerView()
    var selectedCountryCode = "+91"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        setupProgressHud(view: view)
        // Do any additional setup after loading the view.
        countryCodeField.text = "India (+91)"
        countryCodeField.inputView = pickerView
        //GetCountryList()
        CountryArray = [["countryCode":"+91","name":"India"],["countryCode":"+1","name":"Canada"]]
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 11
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - Api methods
    func GetCountryList() {
      
        view.showProgress()
        let header: HTTPHeaders = [
            
           "Authorization" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        netwoking.GetCountryList(apiMethod: "countryList", parameters: "", headers: header) { (response) in
            self.view.dismissProgress()
            switch response.result {
                    
                        case .success(_):
                    print(response.result.value as Any )
            
                    if let dic =  response.result.value as? [String : Any]{
                        

                        if let responsedic = dic["data"] as? [NSDictionary]{
            
                            self.CountryArray = responsedic
                            self.pickerView.delegate = self
                            self.pickerView.dataSource = self
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
        let parameters: [String: Any] = ["phone_number" : selectedCountryCode + phoneNumberField.text!]
        
        
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
                            let VC = self.storyboard?.instantiateViewController(identifier: "VerifyOtpCodeVC") as! VerifyOtpCodeVC
                            VC.otpStr = responsedic["otp"] as? Int32
                            VC.phoneNumber = self.selectedCountryCode + self.phoneNumberField.text!
                            self.navigationController?.pushViewController(VC, animated: true)
                            
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
    
    @IBAction func continueBtnAction(_ sender: UIButton) {
        
        guard let countryCode = self.countryCodeField.text, countryCode.trimmingCharacters(in: .whitespaces).count > 0 else {
                self.showSnackBarAlert(messageStr: "Please select country code.")
                return
            }
        guard let phone = self.phoneNumberField.text, phone.count >= 10 else {
                self.showSnackBarAlert(messageStr: "Please enter valid phone number.")
                return
            }

//        guard let phone1 = self.phoneNumberField.text, phone1.count <= 15 else {
//            self.showSnackBarAlert(messageStr: "Phone number should not be more than 15 digit")
//            return
//        }
        sendOTP()
        //PushTo(FromVC: self, ToStoryboardID: "VerifyOtpCodeVC")
    }
    
    @IBAction func terrmsConditionAction(_ sender: UIButton) {
        PushTo(FromVC: self, ToStoryboardID: "TermsConditionsVC")
    }
    @IBAction func privacyPolicyAction(_ sender: UIButton) {
        PushTo(FromVC: self, ToStoryboardID: "PrivacyPolicyVC")
    }
}

extension LoginVC: UIPickerViewDelegate,UIPickerViewDataSource{
    // MARK: UIPickerView Delegation

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CountryArray.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
     return CountryArray[row]["name"] as? String
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //countryCodeField.text = "India (+91)"
        countryCodeField.text = "\(CountryArray[row]["name"]!) (\(CountryArray[row]["countryCode"]!))"
        selectedCountryCode = "\(CountryArray[row]["countryCode"]!)"
    }
}
