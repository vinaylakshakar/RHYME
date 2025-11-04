//
//  HomeVC.swift
//  RHYME
//
//  Created by Silstone on 18/10/21.
//

import UIKit
import iProgressHUD
import Alamofire

class HomeVC: UIViewController {

    @IBOutlet weak var menuCollection: UICollectionView!
    var menuArray = ["My Tasks","Projects","Forms"]
    @IBOutlet weak var formContainerView: UIView!
    @IBOutlet weak var myTaskContainerView: UIView!
    @IBOutlet weak var projectsContainerView: UIView!
    var selectedIndexPath:IndexPath?
    var netwoking = NetworkApi()
    var userProfileDict = NSDictionary()
    @IBOutlet weak var userNameField: UILabel!
    @IBOutlet weak var designationField: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupProgressHud(view: view)
        setLayout()
        // Do any additional setup after loading the view.
    }
    
    func setLayout() {
        var hasTopNotch: Bool {
            if #available(iOS 11.0, tvOS 11.0, *) {
                return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
            }
            return false
        }
        
        if !hasTopNotch {
            topConstraint.constant = topConstraint.constant + 20
        }
        _APP_MANAGER.setUserOnboarded(state: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addMenuBtn"), object: nil, userInfo: nil)
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
                        

                        if let responsedic = dic["data"] as? [String : Any]{
                            self.userProfileDict = responsedic as NSDictionary
                            print(self.userProfileDict)
                            let userinfo = responsedic.nullKeyRemoval()
                            _APP_MANAGER.saveUserInfo(userinfo as NSDictionary)
                           // self.settingTable.reloadData()
                            let first_name = self.userProfileDict["first_name"] as? String
                            let last_name = self.userProfileDict["last_name"] as? String
                            self.userNameField.text  =  "\(first_name ?? "")" + " \(last_name ?? "")"
                            //self.userNameField.text = self.userProfileDict["first_name"] as? String
                            self.designationField.text = self.userProfileDict["designation"] as? String
                            if let urlStr = self.userProfileDict["profile_url"] as? String {
                                self.profileImage.sd_setImage(with: URL(string: urlStr), placeholderImage: UIImage(named: "j33ao14x-4"))
                            }
                            _APP_MANAGER.saveAuthorizationToken(self.userProfileDict["access_token"] as! String)
                        }
                   
                    
                   
                }  else {
                        
                                
                        }
                
                
                case .failure(let error):
                print(error)
                            
                break
            }
        }
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        self.tabBarController?.tabBar.isHidden = true
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeMenuBtn"), object: nil, userInfo: nil)
//    }

    @IBAction func searchBtnAction(_ sender: UIButton) {
        PushTo(FromVC: self, ToStoryboardID: "SearchVC")
    }
}

extension HomeVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectionViewCell", for: indexPath) as! SelectionViewCell
        cell.manuLable.text = menuArray[indexPath.row]
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
        selectedIndexPath = indexPath
        if indexPath.row == 0 {
            myTaskContainerView.isHidden = false
            projectsContainerView.isHidden = true
            formContainerView.isHidden = true
        }
        if indexPath.row == 1 {
            projectsContainerView.isHidden = false
            myTaskContainerView.isHidden = true
            formContainerView.isHidden = true
        }
        if indexPath.row == 2 {
            formContainerView.isHidden = false
            projectsContainerView.isHidden = true
            myTaskContainerView.isHidden = true
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let collectionViewWidth = collectionView.bounds.size.width
        if indexPath.row == 1 {
            return CGSize(width: 86, height: 39)
        }
        if indexPath.row == 2 {
            return CGSize(width: 74, height: 39)
        }
        return CGSize(width: 114, height: 39)
    }
    
}
//MARK: - Private Functions -
private extension HomeVC {
    func registerCell() {
    menuCollection.register(UINib(nibName: "SelectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "SelectionViewCell")
    }
    
}
