//
//  ComplianceFormVC.swift
//  RHYME
//
//  Created by Silstone on 15/10/21.
//

import UIKit

class ComplianceFormVC: UIViewController {
    
    @IBOutlet weak var signatureView: Canvas!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func crossButtonAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeSignature"), object: nil, userInfo: nil)
    }
    
    @IBAction func doneBtnAction(_ sender: UIButton) {
        if signatureView.isEmpty {
            //showAlert("Please draw something")
            showSnackBarAlert(messageStr: "Please add your signature.")
            return
        }
        
        if let image = signatureView.getDesign {
            print(image)
            let imageDataDict:[String: Any] = ["image": image]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeSignature"), object: nil, userInfo: imageDataDict)
        }
     
    }
    
    @IBAction fileprivate func clearSignature(_ sender: UIButton) {
        signatureView.clear()
    }
}
