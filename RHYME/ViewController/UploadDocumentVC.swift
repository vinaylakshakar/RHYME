//
//  UploadDocumentVC.swift
//  RHYME
//
//  Created by Silstone on 12/10/21.
//

import UIKit
import CropViewController

class UploadDocumentVC: UIViewController {

    @IBOutlet weak var optionTable: UITableView!
    var documentOptionArray = ["License","First Aid","Safety","Certification","Education"]
    @IBOutlet weak var documentField: UITextField!
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var documentImage: UIImageView!
    @IBOutlet weak var selectDocumentView: UIView!
    @IBOutlet weak var showDocumentView: UIView!
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    private var croppingStyle = CropViewCroppingStyle.default
    private var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setLayout()  {
        self.selectDocumentView.isHidden = false
        self.documentImage.image = nil
        self.documentField.text = ""
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func deleteBtnAction(_ sender: UIButton) {
        self.selectDocumentView.isHidden = false
        self.documentImage.image = nil
    }
    
    
    @IBAction func removeViewAction(_ sender: UIButton) {
        setLayout()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeUploadView"), object: nil, userInfo: nil)
        
    }
    @IBAction func selectDocumentButton(_ sender: UIButton) {
        optionTable.isHidden = false
    }
    
    @IBAction func uploadDocumentAction(_ sender: UIButton) {
        
        guard let document = self.documentField.text, document.trimmingCharacters(in: .whitespaces).count > 0 else {
                self.showSnackBarAlert(messageStr: "Please select document type.")
                return
            }
        guard let image = self.documentImage.image else {
            showSnackBarAlert(messageStr: "Please select Document image")
            return
        }
        let imageDataDict:[String: Any] = ["image": image,"documentType":self.documentField.text!]
       // Dict["image"] = self.documentImage.image
       // Dict["documentType"] = self.documentField.text
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeUploadView"), object: nil, userInfo: imageDataDict)
        setLayout()
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

extension UploadDocumentVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentOptionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        cell.textLabel?.text = documentOptionArray[indexPath.row]
        cell.textLabel?.font = UIFont(name:"Lato-Regular",size:17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        documentField.text = documentOptionArray[indexPath.row]
        optionTable.isHidden = true
        tableView.reloadData()
    }
    
    
}

extension UploadDocumentVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//
//            self.documentImage.image = image
//            self.selectDocumentView.isHidden = true
//
//        }
//
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//
//        imagePicker.dismiss(animated: true, completion: nil)
//
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        //cropController.modalPresentationStyle = .fullScreen
        cropController.delegate = self
        
        // Uncomment this if you wish to provide extra instructions via a title label
        //cropController.title = "Crop Image"
    
        // -- Uncomment these if you want to test out restoring to a previous crop setting --
        //cropController.angle = 90 // The initial angle in which the image will be rotated
        //cropController.imageCropFrame = CGRect(x: 0, y: 0, width: 2848, height: 4288) //The initial frame that the crop controller will have visible.
    
        // -- Uncomment the following lines of code to test out the aspect ratio features --
        cropController.aspectRatioPreset = .presetSquare; //Set the initial aspect ratio as a square
        cropController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized away from it
       // cropController.customAspectRatio = CGSize(width: 324, height: 183)
        //cropController.resetAspectRatioEnabled = false // When tapping 'reset', the aspect ratio will NOT be reset back to default
        cropController.aspectRatioPickerButtonHidden = true
    
        // -- Uncomment this line of code to place the toolbar at the top of the view controller --
        //cropController.toolbarPosition = .top
    
        //cropController.rotateButtonsHidden = true
        cropController.rotateClockwiseButtonHidden = true
    
        //cropController.doneButtonTitle = "Title"
        //cropController.cancelButtonTitle = "Title"
        
        //cropController.toolbar.doneButtonHidden = true
        //cropController.toolbar.cancelButtonHidden = true
        //cropController.toolbar.clampButtonHidden = true

        self.image = image
        
        //If profile picture, push onto the same navigation stack
        if croppingStyle == .circular {
            if picker.sourceType == .camera {
                picker.dismiss(animated: true, completion: {
                    self.present(cropController, animated: true, completion: nil)
                })
            } else {
                picker.pushViewController(cropController, animated: true)
            }
        }
        else { //otherwise dismiss, and then present from the main controller
            picker.dismiss(animated: true, completion: {
                self.present(cropController, animated: true, completion: nil)
                //self.navigationController!.pushViewController(cropController, animated: true)
            })
        }
    }
}
extension UploadDocumentVC:CropViewControllerDelegate {
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        //profileImage.image = image
       // layoutImageView()
        self.documentImage.image = image
        self.selectDocumentView.isHidden = true
        
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        
        if cropViewController.croppingStyle != .circular {
            //imageView.isHidden = true
            
            cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,
                                                   toView: documentImage,
                                                   toFrame: CGRect.zero,
                                                   setup: { //self.layoutImageView()
                                                   // self.imageheightConstant.constant = 183
            },
                                                   completion: {
                                                   // self.imageView.isHidden = false
                                                    
            })
        }
        else {
            //self.imageView.isHidden = false
            cropViewController.dismiss(animated: true, completion: nil)
        }
    }
}
