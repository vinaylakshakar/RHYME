//
//  SettingsVC.swift
//  RHYME
//
//  Created by Silstone on 14/10/21.
//

import UIKit
import iProgressHUD
import Alamofire

class SettingsVC: UIViewController {
    @IBOutlet weak var settingTable: UITableView!
    var identifireArray = ["firstCell","secondCell"]
    var netwoking = NetworkApi()
    var userProfileDict = NSDictionary()
    @IBOutlet weak var versionLable: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        setupProgressHud(view: view)
        // Do any additional setup after loading the view.
        //First get the nsObject by defining as an optional anyObject
//        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleVersion"] as AnyObject
        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let version = nsObject as! String
        print("app version-",version)
        versionLable.text = "Version: " + version
        //GetProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addMenuBtn"), object: nil, userInfo: nil)
        userProfileDict = _APP_MANAGER.userInfo
        settingTable.reloadData()
        GetProfile()
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
    func GetProfile() {
      
        view.showProgress()
        let header: HTTPHeaders = [
            
            "Authorization" : "Token " + _APP_MANAGER.userAuthorizationToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        netwoking.GetProfile(apiMethod: "", parameters: "", headers: header) { (response) in
            self.view.dismissProgress()
            switch response.result {
                    
                        case .success(_):
                    print(response.result.value as Any )
            
                    if let dic =  response.result.value as? [String : Any]{
                        
                        if (dic["code"] as! Int == 200) {
//                            if let responsedic = dic["data"] as? [String : Any]{
//                                self.userProfileDict = responsedic as NSDictionary
//                                _APP_MANAGER.saveAuthorizationToken(responsedic["access_token"] as! String)
//                                self.settingTable.reloadData()
//                            }
                        }else if (dic["code"] as! Int == 401){
                            let message = dic["message"] as? String
                            //self.showSnackBarAlert(messageStr: message ?? "user deactivated by admin")
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
    
    func userLogout() {
        view.showProgress()
        let header: HTTPHeaders = [
            "Authorization" : "Token " + _APP_MANAGER.userAuthorizationToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]

        let parameters = [String: Any]()
        netwoking.UnivarsalPostApi(headers: header, apiMethod: kuesrLogout, params: parameters) { (response) in
            print(kuesrLogout)
            print(parameters)
            self.view.dismissProgress()
            switch response.result {

            case .success(_):



                print(response.result.value as Any)

                if let dic =  response.result.value as? [String : Any]{

                    if (dic["code"] as! Int == 200) {
                        if let responsedic =  dic["data"] as? [String : Any] {
                            print(responsedic)
//                            _APP_MANAGER.saveAuthorizationToken(responsedic["access_token"] as! String)
//                            PushTo(FromVC: self, ToStoryboardID: "CompleteProfileVC")
                            

                        }
                        _APP_MANAGER.logoutUser()
                        self.showSnackBarAlert(messageStr: "User Logout successfully")

                    }
                }  else {
                      self.showSnackBarAlert(messageStr: "There is some Error in backend.")
                }


            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    @IBAction func editProfileAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "CompleteProfileVC") as! CompleteProfileVC
        vc.isFromSetting = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func convertDateFormater(dateStr: String) -> String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormatter.date(from: dateStr)
            dateFormatter.dateFormat = "yyyy"
            return  dateFormatter.string(from: date!)

        }
    
    @IBAction func helpBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func logoutBtnAction(_ sender: UIButton) {
           userLogout()
//        _APP_MANAGER.logoutUser()
//        self.showSnackBarAlert(messageStr: "User Logout successfully")
    }
    
}

//MARK: - Tableview Delegate and Datasource -
extension SettingsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifire = identifireArray[indexPath.row]
        let cell = settingTable.dequeueReusableCell(withIdentifier: identifire, for: indexPath) as! SettingViewCell
        if indexPath.row == 0 {
            let first_name = self.userProfileDict["first_name"] as? String
            let last_name = self.userProfileDict["last_name"] as? String
            cell.userNameField.text =  "\(first_name ?? "")" + " \(last_name ?? "")"
            cell.userEmailField.text = self.userProfileDict["email"] as? String
            if let urlStr = self.userProfileDict["profile_url"] as? String {
                cell.profileImage.sd_setImage(with: URL(string: urlStr), placeholderImage: UIImage(named: "j33ao14x-4"))
            }
        }else{
            cell.designationField.text = self.userProfileDict["designation"] as? String
            if let Date = self.userProfileDict["register_on"] as? String {
                cell.emailField.text = "Employee since " + convertDateFormater(dateStr: Date)
            }
        }
        
        return cell
    }
    
    
}

