//
//  TaskDetailsVC.swift
//  RHYME
//
//  Created by Silstone on 19/10/21.
//

import UIKit
import iProgressHUD
import Alamofire

class TaskDetailsVC: UIViewController {

    @IBOutlet weak var reportView: UIView!
    var taskDetailDict = NSDictionary()
    var netwoking = NetworkApi()
    @IBOutlet weak var hourField: UITextField!
    @IBOutlet weak var taskNameLable: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var end_dateLable: UILabel!
    @IBOutlet weak var projectNameLable: UILabel!
    @IBOutlet weak var markCompleteLable: UILabel!
    @IBOutlet weak var markImage: UIImageView!
    @IBOutlet weak var markCompleteBtn: UIButton!
    @IBOutlet weak var markCompleteView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgressHud(view: view)
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.removeReportView(_:)), name: NSNotification.Name(rawValue: "removeReportView"), object: nil)
        setLayOut()
    }
    
    func setLayOut() {
        
        taskNameLable.text = taskDetailDict["title"] as? String
        descriptionLable.text = taskDetailDict["description"] as? String
        let projectDict = taskDetailDict["assigned_project"] as? NSDictionary
        if let projectName = projectDict?["name"] as? String {
            projectNameLable.text = projectName
        }
        //projectNameLable.text = projectDict!["name"] as? String
        
        if let dateStr = taskDetailDict["end_date"] as? String {
            end_dateLable.text = convertDateFormaterToDate(dateStr: dateStr)
        }else{
            end_dateLable.text = " N/A"
        }
        let task_status = taskDetailDict["task_status"] as? String
        if task_status == "2" {
            markCompleteBtn.isHidden = true
            markImage.image = UIImage.init(named: "plus-circle-4")
            markCompleteLable.text = "Completed"
            markCompleteLable.textColor = UIColor(red: 0.00, green: 0.74, blue: 0.43, alpha: 1.00)
            markCompleteView.borderColorV = markCompleteLable.textColor
        }
    }
    
    func convertDateFormaterToDate(dateStr: String) -> String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormatter.date(from: dateStr)
            dateFormatter.dateFormat = "dd MMM yyyy"
            return  dateFormatter.string(from: date!)

        }
    // handle notification
    @objc func removeReportView(_ notification: NSNotification) {
        self.reportView.isHidden = true
        if let Dict = notification.userInfo as? Dictionary<String,Any> {
          // do something with your image
            print(Dict)
            var params = [String:Any]()
            params["issue"] = Dict["issue"]
            params["comment"] = Dict["comment"]
            params["taskId"] = taskDetailDict["id"]
            self.reportTask(parameters: params)
            //documentArray.append(Dict as NSDictionary)
          }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeMenuBtn"), object: nil, userInfo: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: - Api methods
    func reportTask(parameters:[String:Any]) {
        
        let header: HTTPHeaders = [
            "Authorization" : "Token " + _APP_MANAGER.userAuthorizationToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        view.showProgress()
        netwoking.UnivarsalPostApi(headers: header, apiMethod: kreportTask, params: parameters) { (response) in
            print(kreportTask)
            print(parameters)
            self.view.dismissProgress()
            switch response.result {
                
            case .success(_):
                
                
                
                print(response.result.value as Any)
                
                if let dic =  response.result.value as? [String : Any]{
                    
                    if (dic["code"] as! Int == 200) {
                        if let responsedic =  dic["data"] as? [String : Any] {
                            print(responsedic)
                            
                            
                        }
                        
                    }
                }  else {
                    
                    
                }
                self.showSnackBarAlert(messageStr: "Issue Reported Successfully.")
                self.navigationController?.popToRootViewController(animated: true)
                
                
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addReportAction(_ sender: UIButton) {
        self.reportView.isHidden = false
        
    }
    
    @IBAction func markAsCompleteAction(_ sender: UIButton) {
        //self.reportView.isHidden = false
        guard let hour = self.hourField.text, hour.count>0  else {
            showSnackBarAlert(messageStr: "Please enter completed task hour.")
            return
        }
        let VC = self.storyboard?.instantiateViewController(identifier: "JobCompletionVC") as! JobCompletionVC
        VC.task_idStr = taskDetailDict["id"] as! Int
        VC.hoursStr = hour
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
}
