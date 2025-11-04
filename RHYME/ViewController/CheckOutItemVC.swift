//
//  CheckOutItemVC.swift
//  RHYME
//
//  Created by Silstone on 19/10/21.
//

import UIKit
import iProgressHUD
import Alamofire

class CheckOutItemVC: UIViewController {

    @IBOutlet weak var projectField: UITextField!
    @IBOutlet weak var optionTable: UITableView!
    var qr_codeStr = ""
    var netwoking = NetworkApi()
    @IBOutlet weak var discriptionField: UITextField!
    @IBOutlet weak var expectedReturnDateField: UITextField!
    var projectNameArray = [NSDictionary]()
    var projectID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgressHud(view: view)
        // Do any additional setup after loading the view.
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        datePickerView.preferredDatePickerStyle = .wheels
        datePickerView.minimumDate = Date()
        expectedReturnDateField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        expectedReturnDateField.text = dateFormatter.string(from: Date())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeMenuBtn"), object: nil, userInfo: nil)
        getProjectList()
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM-dd"
       // dateFormatter.dateFormat = "MMM dd, yyyy"
        expectedReturnDateField.text = dateFormatter.string(from: sender.date)
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
    func getProjectList() {
      
        view.showProgress()
        let header: HTTPHeaders = [
            
            "Authorization" : "Token " + _APP_MANAGER.userAuthorizationToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        netwoking.getProject(apiMethod: "", parameters: "", headers: header) { [self] (response) in
            self.view.dismissProgress()
            switch response.result {
                    
                        case .success(_):
                    print(response.result.value as Any )
            
                    if let dic =  response.result.value as? [String : Any]{
                        

                        if let responseArray = dic["data"] as? NSArray {
                            print("data-",responseArray)
                            self.projectNameArray = responseArray as! [NSDictionary]
                            self.optionTable.reloadData()
                            
                        }
                   
                    
                   
                }  else {
                        
                                
                        }
                
                
                case .failure(let error):
                print(error)
                            
                break
            }
        }
    }
    func checkoutProduct() {
        view.showProgress()
        let header: HTTPHeaders = [
            "Authorization" : "Token " + _APP_MANAGER.userAuthorizationToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]

        let parameters: [String: Any] = ["qr_code" : qr_codeStr,"status" : "2","description" : self.discriptionField.text!,"expected_return_on" : self.expectedReturnDateField.text!,"project_id":projectID ?? 310]


        netwoking.UnivarsalPostApi(headers: header, apiMethod: kchangeStatus, params: parameters) { (response) in
            print(kchangeStatus)
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
                        self.showSnackBarAlert(messageStr: "Item checkout successfully.")
                        self.tabBarController?.selectedIndex = 3
                        self.navigationController?.popViewController(animated: false)

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
    
    @IBAction func checkOutButtonAction(_ sender: UIButton) {
//        self.tabBarController?.selectedIndex = 3
//        self.navigationController?.popViewController(animated: false)
        guard let description = self.discriptionField.text, description.trimmingCharacters(in: .whitespaces).count > 0 else {
                self.showSnackBarAlert(messageStr: "Please Enter item Description.")
                return
            }
        guard let ReturnDateField = self.expectedReturnDateField.text, ReturnDateField.trimmingCharacters(in: .whitespaces).count > 0 else {
                self.showSnackBarAlert(messageStr: "Please Enter Expected Return Date.")
                return
            }
        guard let project = self.projectField.text, project.trimmingCharacters(in: .whitespaces).count > 0 else {
                self.showSnackBarAlert(messageStr: "Please select Select Project.")
                return
            }
        checkoutProduct()
        
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectProjectButton(_ sender: UIButton) {
        if optionTable.isHidden {
            optionTable.isHidden = false
        }else{
            optionTable.isHidden = true
        }
       
    }

}
extension CheckOutItemVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        projectNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        let projectDict = projectNameArray[indexPath.row]
        cell.textLabel?.text = projectDict["name"] as? String
        cell.textLabel?.font = UIFont(name:"Lato-Regular",size:17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let projectDict = projectNameArray[indexPath.row]
        projectField.text = projectDict["name"] as? String
        projectID = projectDict["id"] as? Int
        optionTable.isHidden = true
        tableView.reloadData()
    }
    
    
}
