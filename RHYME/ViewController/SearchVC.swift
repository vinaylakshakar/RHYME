//
//  SearchVC.swift
//  RHYME
//
//  Created by Silstone on 20/10/21.
//

import UIKit
import iProgressHUD
import Alamofire

class SearchVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchTable: UITableView!
    var netwoking = NetworkApi()
    var searchedTaskArray = [NSDictionary]()
    var searchedFormArray = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupProgressHud(view: view)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeMenuBtn"), object: nil, userInfo: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchTask()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.count > 0 {
            searchTask()
        }
        
    }
    
    func textFieldShouldClear (_ textField: UITextField) -> Bool {
           clearSearch()
           return true

    }
    
    func clearSearch() {
        searchField.text = ""
        searchTable.isHidden = true
        self.view.endEditing(true)
        searchedTaskArray.removeAll()
        searchedFormArray.removeAll()
        searchTable.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func searchTask() {
        view.showProgress()
        let header: HTTPHeaders = [
            "Authorization" : "Token " + _APP_MANAGER.userAuthorizationToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]

        let parameters: [String: Any] = ["searchValue": searchField.text ?? ""]
        netwoking.UnivarsalPostApi(headers: header, apiMethod: ksearchTask, params: parameters) { (response) in
            print(ksearchTask)
            print(parameters)
            self.view.dismissProgress()
            switch response.result {

            case .success(_):



                print(response.result.value as Any)

                if let dic =  response.result.value as? [String : Any]{

                    if (dic["code"] as! Int == 200) {
                        if let responsedic =  dic["data"] as? [String : Any] {
                            print(responsedic)
                            if let taskArray = responsedic["task"] as? [NSDictionary] {
                                print("taskArray-",taskArray)
                                self.searchedTaskArray = taskArray
                        
                            }
                            if let formsArray = responsedic["forms"] as? [NSDictionary] {
                                print("formsArray-",formsArray)
                                self.searchedFormArray = formsArray
                        
                            }
                            self.searchTable.isHidden = false
                            self.searchTable.reloadData()
//                            _APP_MANAGER.saveAuthorizationToken(responsedic["access_token"] as! String)
//                            PushTo(FromVC: self, ToStoryboardID: "CompleteProfileVC")
                            

                        }

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
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func convertDateFormaterToMonth(dateStr: String) -> String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormatter.date(from: dateStr)
            dateFormatter.dateFormat = "MMM"
            return  dateFormatter.string(from: date!)

        }
    func convertDateFormaterToDate(dateStr: String) -> String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormatter.date(from: dateStr)
            dateFormatter.dateFormat = "dd"
            return  dateFormatter.string(from: date!)

        }

}
//MARK: - Tableview Delegate and Datasource -
extension SearchVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
            
            let label = UILabel()
            label.frame = CGRect.init(x: 0, y:5, width: headerView.frame.width, height: headerView.frame.height-10)
        if section == 0 {
            label.text = "       Tasks"
        }else{
            label.text = "       Forms"
        }
           
            label.font = .systemFont(ofSize: 16)
            label.textColor = UIColor.darkGray
            label.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.00)
            headerView.backgroundColor = UIColor.white
            
            headerView.addSubview(label)
            
            return headerView
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 30
        }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return searchedTaskArray.count
        }
        return searchedFormArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = searchTable.dequeueReusableCell(withIdentifier: "MyTaskCell", for: indexPath) as! MyTaskCell
            let taskDict = searchedTaskArray[indexPath.row]
            cell.taskNameLable.text = taskDict["title"] as? String
            let projectDict = taskDict["assigned_project"] as? NSDictionary
            cell.projectNameLable.text = projectDict!["name"] as? String
            
            if let dateStr = taskDict["end_date"] as? String {
                cell.taskEnd_date.text = convertDateFormaterToDate(dateStr: dateStr)
                cell.taskEnd_month.text = convertDateFormaterToMonth(dateStr: dateStr)
            }else{
                cell.taskEnd_date.text = "N/A"
                cell.taskEnd_month.text = "N/A"
            }
            cell.selectionStyle = .none
            return cell
        }
        let cell = searchTable.dequeueReusableCell(withIdentifier: "FormCell", for: indexPath) as! FormCell
        let formDict = searchedFormArray[indexPath.row]
        cell.formTypeLable.text = "FLHA"
        //let projectDict = formDict["assigned_project"] as? NSDictionary
        cell.projectNameLable.text = formDict["title"] as? String
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //PushTo(FromVC: self, ToStoryboardID: "TaskDetailsVC")
        if indexPath.section == 0{
            let VC = self.storyboard?.instantiateViewController(identifier: "TaskDetailsVC") as! TaskDetailsVC
            VC.taskDetailDict = searchedTaskArray[indexPath.row]
            self.navigationController?.pushViewController(VC, animated: true)
        }else{
            let VC = self.storyboard?.instantiateViewController(identifier: "FLHAVC") as! FLHAVC
            VC.FLHAformInfoDict = searchedFormArray[indexPath.row]
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
    }
}
//MARK: - Private Functions -
private extension SearchVC {
    func registerCell() {
        searchTable.register(UINib(nibName: "FormCell", bundle: Bundle.main), forCellReuseIdentifier: "FormCell")
        searchTable.register(UINib(nibName: "MyTaskCell", bundle: Bundle.main), forCellReuseIdentifier: "MyTaskCell")
        
    }
    
}
