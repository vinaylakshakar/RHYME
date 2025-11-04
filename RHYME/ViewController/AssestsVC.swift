//
//  AssestsVC.swift
//  RHYME
//
//  Created by Silstone on 13/10/21.
//

import UIKit
import iProgressHUD
import Alamofire

class AssestsVC: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var assetTable: UITableView!
    var netwoking = NetworkApi()
    var issuedItemArray = [NSDictionary]()
    var pendingItemArray = [NSDictionary]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupProgressHud(view: view)
        // Do any additional setup after loading the view.
//        let attr = NSDictionary(object: UIFont(name: "HelveticaNeue-Bold", size: 16.0)!, forKey: NSFontAttributeName as NSCopying)
        let font =  UIFont(name: "Lato-Regular", size: 14.0)!
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font: font], for: UIControl.State.selected)
        self.assetTable.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addMenuBtn"), object: nil, userInfo: nil)
        GetformInventory()
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
    func GetformInventory() {
        issuedItemArray.removeAll()
        pendingItemArray.removeAll()
        
        view.showProgress()
        let header: HTTPHeaders = [
            
            "Authorization" : "Token " + _APP_MANAGER.userAuthorizationToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        netwoking.GetformInventory(apiMethod: "", parameters: "", headers: header) { [self] (response) in
            self.view.dismissProgress()
            switch response.result {
                    
                        case .success(_):
                    print(response.result.value as Any )
            
                    if let dic =  response.result.value as? [String : Any]{
                        
                        if (dic["code"] as! Int == 200) {
                            if let responsedicArray = dic["data"] as? [NSDictionary]{
                                print(responsedicArray)
                                for Dict in responsedicArray {
                                    let statusStr = Dict["status"] as? String
                                    if statusStr == "2" {
                                        self.issuedItemArray.append(Dict)
                                    }else if statusStr == "3"{
                                        self.pendingItemArray.append(Dict)
                                    }
                                }
                                assetTable.reloadData()
                            }
                        }else if (dic["code"] as! Int == 401){
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
    
    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        assetTable.reloadData()
    }
    
    @objc func returnAsset(sender:UIButton) {
        //PushTo(FromVC: self, ToStoryboardID: "ReturnProductVC")
        let ItemDict =  issuedItemArray[sender.tag]
        let vc = self.storyboard?.instantiateViewController(identifier: "ReturnProductVC") as! ReturnProductVC
        vc.qr_codeStr = (ItemDict["qr_code"] as? String)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - Tableview Delegate and Datasource -
extension AssestsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 1 {
            return pendingItemArray.count
        }
        return issuedItemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = assetTable.dequeueReusableCell(withIdentifier: "AssetsCell", for: indexPath) as! AssetsCell
        
        if segmentedControl.selectedSegmentIndex == 1 {
            cell.returnAssetView.isHidden = true
            let ItemDict =  pendingItemArray[indexPath.row]
            cell.itemName.text = ItemDict["name"] as? String
            cell.itemDescription.text = ItemDict["description"] as? String
            if let urlStr = ItemDict["img_url"] as? String {
                cell.itemImageView.sd_setImage(with: URL(string: urlStr), placeholderImage: UIImage(named: "j33ao14x-4"))
            }

        }else{
            cell.returnAssetView.isHidden = false
            let ItemDict =  issuedItemArray[indexPath.row]
            cell.itemName.text = ItemDict["name"] as? String
            cell.itemDescription.text = ItemDict["description"] as? String
            cell.returnAssetButton.tag = indexPath.row
            cell.returnAssetButton.addTarget(self, action: #selector(returnAsset), for: .touchUpInside)
            if let urlStr = ItemDict["img_url"] as? String {
                cell.itemImageView.sd_setImage(with: URL(string: urlStr), placeholderImage: UIImage(named: "Group 4224"))
            }

        }
       
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if segmentedControl.selectedSegmentIndex == 0 {
//            PushTo(FromVC: self, ToStoryboardID: "ReturnProductVC")
//        }
//
//    }
    
}

//MARK: - Private Functions -
private extension AssestsVC {
    func registerCell() {
        assetTable.register(UINib(nibName: "AssetsCell", bundle: Bundle.main), forCellReuseIdentifier: "AssetsCell")
    }
    
}
