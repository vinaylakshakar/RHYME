//
//  JobCompletionVC.swift
//  RHYME
//
//  Created by Silstone on 30/12/21.
//

import UIKit
import iProgressHUD
import Alamofire

class JobCompletionVC: UIViewController {

    @IBOutlet weak var questionTable: UITableView!
    var questionArray = [[String:Any]]()
    @IBOutlet weak var signedFormView: UIView!
    var isTaskQuestionSelected = false
    var isExplanationAdded = true
    var netwoking = NetworkApi()
    var PostJsonDict = [String: Any]()
    var task_idStr = 313
    var hoursStr = "5"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupProgressHud(view: view)
        // Do any additional setup after loading the view.
        questionArray = [["question":"Are all Permit(s) Closed Out?","option":"","explain":""],["question":"Was the area cleaned up at end of Job/ Shift?","option":"","explain":""],["question":"Are there Hazards Remaining?","option":"","explain":""],["question":"Were there any incidents / Injuries?","option":"","explain":""]]
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.removeSignatureView(_:)), name: NSNotification.Name(rawValue: "removeSignature"), object: nil)
    }
    
    // handle notification
    @objc func removeSignatureView(_ notification: NSNotification) {
        signedFormView.isHidden = true
        if let image = notification.userInfo?["image"] as? UIImage {
          // do something with your image
//            let imageData:NSData = image.pngData()! as NSData
//            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
//            print(strBase64)
            sendImgInMultipart(image: image)
            
            //documentArray.append(Dict as NSDictionary)
          }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getExplanation(question:String) -> String {
        var ExplainStr:String?
        
        switch question {
        case "Are all Permit(s) Closed Out?":
            let indexpathForCell = NSIndexPath(row: 0, section: 0)
            let QuestionCell =  questionTable.cellForRow(at: indexpathForCell as IndexPath)! as! TaskQuestionCell
            ExplainStr = QuestionCell.explanationField.text
        case "Was the area cleaned up at end of Job/ Shift?":
            let indexpathForCell = NSIndexPath(row: 1, section: 0)
            let QuestionCell =  questionTable.cellForRow(at: indexpathForCell as IndexPath)! as! TaskQuestionCell
            ExplainStr = QuestionCell.explanationField.text
        case "Are there Hazards Remaining?":
            let indexpathForCell = NSIndexPath(row: 2, section: 0)
            let QuestionCell =  questionTable.cellForRow(at: indexpathForCell as IndexPath)! as! TaskQuestionCell
            ExplainStr = QuestionCell.explanationField.text
        case "Were there any incidents / Injuries?":
            let indexpathForCell = NSIndexPath(row: 3, section: 0)
            let QuestionCell =  questionTable.cellForRow(at: indexpathForCell as IndexPath)! as! TaskQuestionCell
            ExplainStr = QuestionCell.explanationField.text
        default:
            return ""
        }
        return ExplainStr ?? ""
    }
    
    func task_ques() -> [NSDictionary] {
        var task_quesArray = [NSDictionary]()
        for Dict in questionArray {
            var newDict = [String:Any]()
            newDict["questions"] = Dict["question"]
            
            if let option = Dict["option"] as? Bool{
                if option == true {
                    newDict["answer"] = "Yes"
                    //newDict["ques_type"] = 1
                    newDict["explanation"] = getExplanation(question: Dict["question"] as! String)
                    if newDict["explanation"] as! String == "" {
                        self.showSnackBarAlert(messageStr: "Please Enter Explanation.")
                        isTaskQuestionSelected = true
                        isExplanationAdded = false
                        break
                    }
                }else{
                    newDict["answer"] = "No"
                    //newDict["ques_type"] = 2
                    newDict["explanation"] = ""
                    isTaskQuestionSelected = true
                }
            }else{
                self.showSnackBarAlert(messageStr: "Please Select option.")
                isTaskQuestionSelected = false
                break
            }
            
            task_quesArray.append(newDict as NSDictionary)
           
        }
        return task_quesArray
    }
    
    // MARK: - image multipart
    func sendImgInMultipart(image:UIImage)  {
        self.view.showProgress()
        
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return  }
        var parameters = [String:String]()
        
        parameters = ["type": "form"]
        print(parameters)
        let headers: HTTPHeaders = [
            "Authorization" : "Token " + _APP_MANAGER.userAuthorizationToken,
            "Content-Type": "multipart/form-data",
            "Accept":"application/json"
        ]
        let randomInt = String(Int.random(in: 0..<100))
        let originalString = "\(kBaseUrl)upload/"
        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData, withName: "doc_file", fileName: "profile\(randomInt).jpeg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append(Data(value.utf8), withName: key)
            }
        }, to: urlString,method: .post, headers: headers,
           encodingCompletion: { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                //self.view.dismissProgress()
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                upload.responseJSON { response in
                    if let dic = response.result.value as? [String:Any] {
                        print(dic)
                        if (dic["code"] as! Int == 200) {
                            if let imageUrl =  dic["data"] as? String {
                                print(imageUrl)
                                self.PostJsonDict["sign"]  = imageUrl
                                self.jobCompleteWithSignature(parameters: self.PostJsonDict)
                               // self.Updateprofile(imageUrl: imageUrl)
    //                            _APP_MANAGER.saveAuthorizationToken(responsedic["access_token"] as! String)
    //                            PushTo(FromVC: self, ToStoryboardID: "CompleteProfileVC")
                                

                            }

                        }
                        
                       self.view.dismissProgress()
                        
                    } else {
                        
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                self.view.dismissProgress()
            }
            
        })
    }
    
    
    // MARK: - Api methods
    func markAsCompleteTask() {

        let parameters: [String: Any] = ["ques" : task_ques(),"sign":"","hours":hoursStr,"task_id":task_idStr]
        //let parameters: [String: Any] = ["projectInfo" : _APP_MANAGER.FLHAProjectInfo,"task" : _APP_MANAGER.FLHATaskArray,"hazards" : [12,13],"task_ques" : task_ques()]
        if !isTaskQuestionSelected || !isExplanationAdded{
            return
        }
        
        self.signedFormView.isHidden = false
        PostJsonDict = parameters
        
        
    }
    
    func jobCompleteWithSignature(parameters:[String:Any]) {
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "Authorization" : "Token " + _APP_MANAGER.userAuthorizationToken
        ]
        view.showProgress()
        netwoking.UnivarsalJsonPostApi(headers: header, apiMethod: kmarkAsCompleteTask, params: parameters) { (response) in
            print(kmarkAsCompleteTask)
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
                self.showSnackBarAlert(messageStr: "Job Completed Successfully.")
                self.navigationController?.popToRootViewController(animated: true)
                
                
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    @objc func yesBtnAction(sender:UIButton) {
        var Dict = questionArray[sender.tag]
        Dict["option"] = true
        questionArray[sender.tag] = Dict
        questionTable.reloadData()
    }
    @objc func noBtnAction(sender:UIButton) {
        var Dict = questionArray[sender.tag]
        Dict["option"] = false
        questionArray[sender.tag] = Dict
        questionTable.reloadData()
    }
    
    @IBAction func signFormAction(_ sender: UIButton) {
        //createJsonDict()
        isTaskQuestionSelected = false
        isExplanationAdded = true
        markAsCompleteTask()
       // self.signedFormView.isHidden = false
    }

}
extension JobCompletionVC: UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = questionTable.dequeueReusableCell(withIdentifier: "TaskQuestionCell", for: indexPath) as! TaskQuestionCell
        let Dict = questionArray[indexPath.row]
        cell.taskQuestionLable.text = Dict["question"] as? String
        cell.explainViewConstant.constant = 0
        
        if let isOption = Dict["option"] as? Bool {
            if isOption == false {
                cell.explainViewConstant.constant = 0
                cell.noBtn.isSelected = true
                cell.yesBtn.isSelected = false
                cell.explanationField.text = ""
            }else{
                cell.explainViewConstant.constant = 38.5
                cell.noBtn.isSelected = false
                cell.yesBtn.isSelected = true
            }
        }else{
            cell.explainViewConstant.constant = 0
            cell.noBtn.isSelected = false
            cell.yesBtn.isSelected = false
        }
        
        cell.yesBtn.tag = indexPath.row
        cell.noBtn.tag = indexPath.row
        cell.yesBtn.addTarget(self, action: #selector(yesBtnAction), for: .touchUpInside)
        cell.noBtn.addTarget(self, action: #selector(noBtnAction), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let Dict = questionArray[indexPath.row]
        if Dict["option"] as? Bool == true  {
            return 185
        }
        return 135
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        self.selectedindexpath = indexPath
//        tableView.reloadData()
//    }
}
//MARK: - Private Functions -
private extension JobCompletionVC {
    func registerCell() {
        questionTable.register(UINib(nibName: "TaskQuestionCell", bundle: Bundle.main), forCellReuseIdentifier: "TaskQuestionCell")
    }
    
}
