//
//  ReturnProductVC.swift
//  RHYME
//
//  Created by Silstone on 13/10/21.
//

import UIKit
import iProgressHUD
import Alamofire


class ReturnProductVC: UIViewController {

    var productConditionsArray = ["Working","Not Working","Damaged"]
    @IBOutlet weak var conditionField: UITextField!
    @IBOutlet weak var optionTable: UITableView!
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var assetImage: UIImageView!
    var netwoking = NetworkApi()
    var qr_codeStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgressHud(view: self.view)
        // Do any additional setup after loading the view.
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
    
    // MARK: - Api methods
    func returnProduct(imageUrl:String) {
        view.showProgress()
        let header: HTTPHeaders = [
            "Authorization" : "Token " + _APP_MANAGER.userAuthorizationToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]

        let parameters: [String: Any] = ["qr_code" : qr_codeStr,"status" : "3","img_url" : imageUrl,"condition" : self.conditionField.text!]


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
                        self.showSnackBarAlert(messageStr: "Return request submitted successfully.")
                        self.navigationController?.popViewController(animated: true)

                    }
                }  else {


                }


            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func sendImgInMultipart()  {
        self.view.showProgress()
        
        guard let imageData = self.assetImage.image!.jpegData(compressionQuality: 0.2) else { return  }
        var parameters = [String:String]()
        
        parameters = ["type": "product"]
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
                                self.returnProduct(imageUrl: imageUrl)
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
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func returnButtonAction(_ sender: UIButton) {
        guard let condition = self.conditionField.text, condition.trimmingCharacters(in: .whitespaces).count > 0 else {
                self.showSnackBarAlert(messageStr: "Please select Product Condition.")
                return
            }
        guard let asset = self.assetImage, asset.image != nil else {
                self.showSnackBarAlert(messageStr: "Please select Product Image.")
                return
            }
        sendImgInMultipart()
        //returnProduct(imageUrl: "imageUrl")
    }
    
    @IBAction func selectConditionsButton(_ sender: UIButton) {
        optionTable.isHidden = false
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
    
}


extension ReturnProductVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            self.assetImage.image = image
    
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        imagePicker.dismiss(animated: true, completion: nil)

    }
}

extension ReturnProductVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productConditionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        cell.textLabel?.text = productConditionsArray[indexPath.row]
        cell.textLabel?.font = UIFont(name:"Lato-Regular",size:17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        conditionField.text = productConditionsArray[indexPath.row]
        optionTable.isHidden = true
        tableView.reloadData()
    }
    
    
}
