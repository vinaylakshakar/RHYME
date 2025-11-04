//
//  FLHAVC.swift
//  RHYME
//
//  Created by Silstone on 15/11/21.
//

import UIKit
import iProgressHUD
import Alamofire

class FLHAVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var projectNameField: UITextField!
    @IBOutlet weak var projectMangagerField: UITextField!
    @IBOutlet weak var formanField: UITextField!
    @IBOutlet weak var crewNumberField: UITextField!
    var FLHAformInfoDict = NSDictionary()
    var netwoking = NetworkApi()
    var isFromProjectVC = false
    var taskId:Int64?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        setupProgressHud(view: view)
        // Do any additional setup after loading the view.
//        let datePickerView = UIDatePicker()
//        datePickerView.datePickerMode = .date
//        datePickerView.preferredDatePickerStyle = .wheels
//        dateField.inputView = datePickerView
//        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        GetformFLHA()
        setLayOut()
    }
    func setLayOut() {
        
        if isFromProjectVC {
            //let projectInfoDict = FLHAformInfoDict["assigned_project"] as? [String : Any]
            self.projectNameField.text = "\(FLHAformInfoDict["name"] ?? "")"
            let managerDict = FLHAformInfoDict["manager"] as? [String : Any]
            self.projectMangagerField.text = "\(managerDict?["first_name"] ?? "")" + " \(managerDict?["last_name"] ?? "")"
            let foremanDict = FLHAformInfoDict["foreman"] as? [String : Any]
            self.formanField.text = "\(foremanDict?["first_name"] ?? "")" + " \(foremanDict?["last_name"] ?? "")"
            
        }else{
            let projectInfoDict = FLHAformInfoDict["assigned_project"] as? [String : Any]
            self.projectNameField.text = "\(projectInfoDict?["name"] ?? "")"
            let managerDict = projectInfoDict!["manager"] as? [String : Any]
            self.projectMangagerField.text = "\(managerDict?["first_name"] ?? "")" + " \(managerDict?["last_name"] ?? "")"
            let foremanDict = projectInfoDict!["foreman"] as? [String : Any]
            self.formanField.text = "\(foremanDict?["first_name"] ?? "")" + " \(foremanDict?["last_name"] ?? "")"
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeMenuBtn"), object: nil, userInfo: nil)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd MMM yyyy"
//        dateField.text = dateFormatter.string(from: sender.date)
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        guard let ProjectName = self.projectNameField.text, ProjectName.trimmingCharacters(in: .whitespaces).count > 0 else {
            self.showSnackBarAlert(messageStr: "Please Enter Project Name.")
            return
        }
        guard let ProjectManager = self.projectMangagerField.text, ProjectManager.trimmingCharacters(in: .whitespaces).count > 0 else {
            self.showSnackBarAlert(messageStr: "Please Enter Project Manager name.")
            return
        }
        guard let Foreman = self.formanField.text, Foreman.trimmingCharacters(in: .whitespaces).count > 0 else {
            self.showSnackBarAlert(messageStr: "Please Enter Foreman.")
            return
        }
        guard let NumberinCrew = self.crewNumberField.text, NumberinCrew.trimmingCharacters(in: .whitespaces).count > 0 else {
            self.showSnackBarAlert(messageStr: "Please Enter Number in Crew.")
            return
        }
        setProjectInfoDict()
        let vc = self.storyboard?.instantiateViewController(identifier: "TasksVC") as! TasksVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setProjectInfoDict() {
        var infoDict = [String:Any]()
        
        if isFromProjectVC {
            infoDict["name"] = projectNameField.text
            infoDict["date"] = "2021-11-02 09:22"
            infoDict["task_id"] = taskId
           // let projectInfoDict = FLHAformInfoDict["assigned_project"] as? [String : Any]
            infoDict["project_id"] = FLHAformInfoDict["id"]
            let managerDict = FLHAformInfoDict["manager"] as! [String : Any]
            let foremanDict = FLHAformInfoDict["foreman"] as! [String : Any]
            infoDict["manager"] = "\(String(describing: managerDict["id"]!))"
            infoDict["musterPoint"] = ""
            infoDict["foreman"] = "\(String(describing: foremanDict["id"]!))"
            infoDict["crewCount"] = crewNumberField.text
        }else{
            infoDict["name"] = projectNameField.text
            infoDict["date"] = "2021-11-02 09:22"
            infoDict["task_id"] = FLHAformInfoDict["id"]
            let projectInfoDict = FLHAformInfoDict["assigned_project"] as? [String : Any]
            infoDict["project_id"] = projectInfoDict!["id"]
            let managerDict = projectInfoDict!["manager"] as! [String : Any]
            let foremanDict = projectInfoDict!["foreman"] as! [String : Any]
            infoDict["manager"] = "\(String(describing: managerDict["id"]!))"
            infoDict["musterPoint"] = ""
            infoDict["foreman"] = "\(String(describing: foremanDict["id"]!))"
            infoDict["crewCount"] = crewNumberField.text
        }
        
        _APP_MANAGER.saveLFHAProjectInfo(infoDict as NSDictionary)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    func GetformFLHA() {
      
        view.showProgress()
        let header: HTTPHeaders = [
            
            "Authorization" : "Token " + _APP_MANAGER.userAuthorizationToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        netwoking.GetformFLHA(apiMethod: "", parameters: "", headers: header) { (response) in
            self.view.dismissProgress()
            switch response.result {
                    
                        case .success(_):
                    print(response.result.value as Any )
            
                    if let dic =  response.result.value as? [String : Any]{
                        

                        if let responsedic = dic["data"] as? [String : Any]{
                            print("data-",responsedic)
                           // self.crewNumberField.text = "\(projectInfoDict?["crewCount"] ?? "")"
                            _APP_MANAGER.saveHazardArray(responsedic["hazards"] as! NSArray)
                        }
                   
                    
                   
                }  else {
                        
                                
                        }
                
                
                case .failure(let error):
                print(error)
                            
                break
            }
        }
    }

}
