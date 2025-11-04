//
//  FormVC.swift
//  RHYME
//
//  Created by Silstone on 14/10/21.
//

import UIKit
import iProgressHUD
import Alamofire

class FormVC: UIViewController {

    @IBOutlet weak var formTable: UITableView!
    @IBOutlet weak var formCollection: UICollectionView!
    //var formTypeArray = ["Daily Summary","Lift Inspection","Toolbox Meeting Record","FLHA"]
    var formTypeArray = ["FLHA"]
    var netwoking = NetworkApi()
    var allFormsArray = [NSDictionary]()
    var selectedIndexPath:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupProgressHud(view: view)
        registerCell()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addMenuBtn"), object: nil, userInfo: nil)
        selectedIndexPath = nil
        getFormList()
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
    func getFormList() {
        self.allFormsArray.removeAll()
        view.showProgress()
        let header: HTTPHeaders = [
            
            "Authorization" : "Token " + _APP_MANAGER.userAuthorizationToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        netwoking.getFormList(apiMethod: "", parameters: "", headers: header) { [self] (response) in
            self.view.dismissProgress()
            switch response.result {
                    
                        case .success(_):
                    print(response.result.value as Any )
            
                    if let dic =  response.result.value as? [String : Any]{
                        
                        if (dic["code"] as! Int == 200) {
                            if let responseArray = dic["data"] as? [NSDictionary] {
                                print("data-",responseArray)
                                
                                for formDict in responseArray {
                                    let formStatus = formDict["task_status"] as? String
                                    if formStatus == "0" {
                                        self.allFormsArray.append(formDict)
                                    }
                                }
                               // self.allFormsArray = responseArray as! [NSDictionary]
                                self.formTable.reloadData()
                                self.formCollection.reloadData()
                                
                            }
                        } else if (dic["code"] as! Int == 401){
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

}


extension FormVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionFromCell", for: indexPath) as! CollectionFromCell
        cell.formNameLabel.text = "FLHA"
        cell.formNumberLabel.text = "\(allFormsArray.count)"
        if indexPath == selectedIndexPath {
            cell.selectedView.isHidden = false
        }else{
            if selectedIndexPath == nil && indexPath.row == 0{
                cell.selectedView.isHidden = false
            }else{
                cell.selectedView.isHidden = true
            }
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // PushTo(FromVC: self, ToStoryboardID: "ManteePostDetail")
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let collectionViewWidth = collectionView.bounds.size.width
        
        return CGSize(width: 105, height: 67)
    }
    
}

//MARK: - Tableview Delegate and Datasource -
extension FormVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFormsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = formTable.dequeueReusableCell(withIdentifier: "FormCell", for: indexPath) as! FormCell
        let formDict = allFormsArray[indexPath.row]
        cell.formTypeLable.text = formDict["form_type"] as? String
        //let projectDict = formDict["assigned_project"] as? NSDictionary
        cell.projectNameLable.text = formDict["title"] as? String
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 3 {
//            PushTo(FromVC: self, ToStoryboardID: "FLHAVC")
//        }else{
//            PushTo(FromVC: self, ToStoryboardID: "DailySummaryVC")
//        }
        let VC = self.storyboard?.instantiateViewController(identifier: "FLHAVC") as! FLHAVC
        VC.FLHAformInfoDict = allFormsArray[indexPath.row]
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
}

//MARK: - Private Functions -
private extension FormVC {
    func registerCell() {
        formTable.register(UINib(nibName: "FormCell", bundle: Bundle.main), forCellReuseIdentifier: "FormCell")
        formCollection.register(UINib(nibName: "CollectionFromCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CollectionFromCell")
    }
    
}
