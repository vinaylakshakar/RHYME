//
//  DailySummaryVC.swift
//  RHYME
//
//  Created by Silstone on 14/10/21.
//

import UIKit

class DailySummaryVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.tabBarController?.tabBar.isHidden = true
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
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueBtnAction(_ sender: UIButton) {
        PushTo(FromVC: self, ToStoryboardID: "DailySummaryFormVC")
    }
    
}
