//
//  CompleteProfileVC.swift
//  RHYME
//
//  Created by Silstone on 11/10/21.
//

import UIKit
import iProgressHUD
import Alamofire

class CompleteProfileVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var uploadView: UIView!
    @IBOutlet weak var documentTable: UITableView!
    var documentArray = [NSDictionary]()
    var json_DocumentArray = [NSDictionary]()
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var profileImage: UIImageView!
    var designationOptionArray = ["Electrician","Forman","Manager","Worker","Driver","Operator","Supervisor"]
    @IBOutlet weak var designationTable: UITableView!
    @IBOutlet weak var designationField: UITextField!
    var netwoking = NetworkApi()
    @IBOutlet weak var nameField: UITextField!
    var isFromSetting = false
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    
    @IBOutlet weak var uploadDocLable: UILabel!
    @IBOutlet weak var addDocumentView: UIView!
    var indexValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        setupProgressHud(view: view)
        registerCell()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.removeUploadView(_:)), name: NSNotification.Name(rawValue: "removeUploadView"), object: nil)
        if isFromSetting {
            setLayout()
        }
        let userInfo = _APP_MANAGER.userInfo
        designationField.text = userInfo["designation"] as? String
    }
    
    func setLayout()  {
        
        continueBtn.setTitle("Done", for: .normal)
        let userInfo = _APP_MANAGER.userInfo
        nameField.text = userInfo["display_name"] as? String
        if let urlStr = userInfo["profile_url"] as? String {
            profileImage.sd_setImage(with: URL(string: urlStr), placeholderImage: UIImage(named: "j33ao14x-4"))
        }
        
        backBtn.isHidden = false
        self.titleLable.text = "Edit Profile"
        addDocumentView.isHidden = true
        uploadDocLable.isHidden = true
        documentTable.isScrollEnabled = false
        self.tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeMenuBtn"), object: nil, userInfo: nil)
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
    // MARK: - Documents multipart
    func sendDocumentMultipart(documentName:String,image:UIImage)  {
        self.view.showProgress()
        
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return  }
        var parameters = [String:String]()
        
        parameters = ["type": "documents"]
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
                                var newDict = [String:Any]()
                                newDict["url"] = imageUrl
                                newDict["name"] = documentName
                                newDict["type"] = "image"
                                newDict["description"] = "description"
                                newDict["expiry_date"] = "2021-12-04 00:00"
                                self.json_DocumentArray.append(newDict as NSDictionary)
                                
                                if self.json_DocumentArray.count != self.documentArray.count {
                                    self.indexValue = self.indexValue + 1
                                    let Dict = self.documentArray[self.indexValue]
                                    if let image = Dict["image"] as? UIImage {
                                      // do something with your image
                                        let docName = Dict["documentType"] as? String
                                        self.sendDocumentMultipart(documentName: docName!, image: image)
                                    
                                    }
                                }else{
                                    self.sendImgInMultipart()
                                }
                                

    //                            _APP_MANAGER.saveAuthorizationToken(responsedic["access_token"] as! String)
    //                            PushTo(FromVC: self, ToStoryboardID: "CompleteProfileVC")
                                

                            }

                        }else if (dic["code"] as! Int == 401){
                            let message = dic["message"] as? String
                            //self.showSnackBarAlert(messageStr: message ?? "user deactivated by admin")
                            AppLaunch.showAlertView(title: "Alert!", message: message ?? "user deactivated by admin")
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
    
    // MARK: - image multipart
    func sendImgInMultipart()  {
        self.view.showProgress()
        
        guard let imageData = self.profileImage.image!.jpegData(compressionQuality: 0.2) else { return  }
        var parameters = [String:String]()
        
        parameters = ["type": "profile"]
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
                                self.UpdateProfile(imageUrl: imageUrl, documentArray: self.json_DocumentArray)
                               // self.Updateprofile(imageUrl: imageUrl)
    //                            _APP_MANAGER.saveAuthorizationToken(responsedic["access_token"] as! String)
    //                            PushTo(FromVC: self, ToStoryboardID: "CompleteProfileVC")
                                

                            }

                        }else if (dic["code"] as! Int == 401){
                            let message = dic["message"] as? String
                            //self.showSnackBarAlert(messageStr: message ?? "user deactivated by admin")
                            AppLaunch.showAlertView(title: "Alert!", message: message ?? "user deactivated by admin")
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
    func UpdateProfile(imageUrl:String,documentArray:[NSDictionary]) {
        view.showProgress()
        
        let header: HTTPHeaders = [
            //            "Username": "sdsol",
            //            "Password": "sdsol99",
            //"Authorization" : "application/json",
            "Content-Type" : "application/json",
            "Authorization" : "Token " + _APP_MANAGER.userAuthorizationToken
        ]
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        let DateStr = dateFormatter.string(from: Date())
       // let year = Calendar.current.component(.year, from: Date())
        var parameters =  [String: Any]()
        if isFromSetting {
            parameters = ["display_name" : self.nameField.text ?? "ios_user","designation" : self.designationField.text ?? "developer","register_on":DateStr,"profile_url":imageUrl]
        }else{
            parameters = ["display_name" : self.nameField.text ?? "ios_user","designation" : self.designationField.text ?? "developer","register_on":DateStr,"profile_url":imageUrl,"document":documentArray]
        }

        
        
        netwoking.UpdateprofileApi(headers: header, apiMethod: kupdateProfile, params: parameters) { (response) in
            print(kupdateProfile)
            print(parameters)
            self.view.dismissProgress()
            switch response.result {
                
            case .success(_):
                
                
                
                print(response.result.value as Any)
                
                if let dic =  response.result.value as? [String : Any]{
                    
                    if (dic["code"] as! Int == 200) {
                        if let responsedic =  dic["data"] as? [String : Any] {
                            print("data-",responsedic)
                            let userinfo = responsedic.nullKeyRemoval()
                            _APP_MANAGER.saveUserInfo(userinfo as NSDictionary)
                            //PushTo(FromVC: self, ToStoryboardID: "VerifyOtpCodeVC")
                            if self.isFromSetting {
                                self.navigationController?.popViewController(animated: true)
                            }else{
                                PushTo(FromVC: self, ToStoryboardID: "CustomTabBarController")
                            }
                            
                            
                        }
                        
                    }else if (dic["code"] as! Int == 401){
                        let message = dic["message"] as? String
                        self.showSnackBarAlert(messageStr: message ?? "user deactivated by admin")
                    }
                }  else {
                    
                    
                }
                
                
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    
    

    // handle notification
    @objc func removeUploadView(_ notification: NSNotification) {
        self.uploadView.isHidden = true
        if let image = notification.userInfo?["image"] as? UIImage {
          // do something with your image
            var Dict = [String:Any]()
            Dict["image"]  = image
            Dict["documentType"] = notification.userInfo?["documentType"] as? String
            documentArray.append(Dict as NSDictionary)
          }
        documentTable.reloadData()
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
        
    @IBAction func addDocumentsAction(_ sender: UIButton) {
        self.uploadView.isHidden = false
        
    }
    @IBAction func selectImageAction(_ sender: UIButton) {
        
        OpenGallery()
    }
    
    func OpenGallery() {

        imagePicker.delegate = self
        let optionMenu = UIAlertController(title: nil, message: "Add Photo", preferredStyle: .actionSheet)

        let galleryAction = UIAlertAction(title: "Gallery", style: .default, handler:{
            (alert: UIAlertAction!) -> Void in
            self.addImageOnTapped()
        })

        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler:{
            (alert: UIAlertAction!) -> Void in
            self.openCameraButton()
        })

        let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{
            (alert: UIAlertAction!) -> Void in
            print("Cancel")
        })

        optionMenu.addAction(galleryAction)
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(cancleAction)
        self.present(optionMenu, animated: true, completion: nil)


    }
    
    func addImageOnTapped(){

        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            imagePicker = UIImagePickerController()
             imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true

            self.present(imagePicker, animated: true, completion: nil)
        }

    }
    
    func openCameraButton(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func continueBtnAction(_ sender: UIButton) {
        
        guard let name = self.nameField.text, name.trimmingCharacters(in: .whitespaces).count > 0 else {
                self.showSnackBarAlert(messageStr: "Please enter username.")
                return
            }

        guard let designation = self.designationField.text, designation.trimmingCharacters(in: .whitespaces).count > 0 else {
                self.showSnackBarAlert(messageStr: "Please select designation.")
                return
            }
        let Image: UIImage = UIImage(named: "j33ao14x-4")!
        if (profileImage.image?.isEqualToImage(Image))! {
            self.showSnackBarAlert(messageStr: "Please select profile Image.")
            return
        }
        
        if isFromSetting {
            self.sendImgInMultipart()
        }else{
            if documentArray.count == 0 {
                self.showSnackBarAlert(messageStr: "Please select documents.")
                return
            }
            
            //Updateprofile()
            let Dict = self.documentArray[indexValue]
            if let image = Dict["image"] as? UIImage {
              // do something with your image
                let docName = Dict["documentType"] as? String
                sendDocumentMultipart(documentName: docName!, image: image)
            
            }
           
        }
        
        //sendImgInMultipart()
//        PushTo(FromVC: self, ToStoryboardID: "CustomTabBarController")
    }

    @IBAction func selectdesignationButton(_ sender: UIButton) {
        if designationTable.isHidden {
            designationTable.isHidden = false
        }else{
            designationTable.isHidden = true
        }
        
    }
    
    @objc func deleteDoc(sender:UIButton) {
        documentArray.remove(at: sender.tag)
        documentTable.reloadData()
    }
}

//MARK: - Tableview Delegate and Datasource -
extension CompleteProfileVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == designationTable  {
            return designationOptionArray.count
        }
        return self.documentArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == designationTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                     for: indexPath)
            cell.textLabel?.text = designationOptionArray[indexPath.row]
            cell.textLabel?.font = UIFont(name:"Lato-Regular",size:17)
            return cell
        }
        let cell = documentTable.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath) as! DocumentCell
        let Dict = documentArray[indexPath.row]
        if let image = Dict["image"] as? UIImage {
          // do something with your image
            cell.documentImage.image = image
            cell.documentType.text = Dict["documentType"] as? String
        
        }
        cell.selectionStyle = .none
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteDoc), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == designationTable{
            designationField.text = designationOptionArray[indexPath.row]
            designationTable.isHidden = true
            designationTable.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == designationTable {
            return 44
        }
        return 275
    }
    
}

extension CompleteProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            self.profileImage.image = image
    
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        imagePicker.dismiss(animated: true, completion: nil)

    }
}

//MARK: - Private Functions -
private extension CompleteProfileVC {
    func registerCell() {
        documentTable.register(UINib(nibName: "DocumentCell", bundle: Bundle.main), forCellReuseIdentifier: "DocumentCell")
    }
    
}
extension Dictionary {
    func nullKeyRemoval() -> Dictionary {
        var dict = self

        let keysToRemove = Array(dict.keys).filter { dict[$0] is NSNull }
        for key in keysToRemove {
            dict.removeValue(forKey: key)
        }

        return dict
    }
}
extension UIImage {

    func isEqualToImage(_ image: UIImage) -> Bool {
        return self.pngData() == image.pngData()
    }

}
