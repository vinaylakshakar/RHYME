//
//  ReportIssueVC.swift
//  RHYME
//
//  Created by Silstone on 02/11/21.
//

import UIKit

class ReportIssueVC: UIViewController,UITextViewDelegate {

    @IBOutlet weak var optionTable: UITableView!
    var reasonOptionArray = ["Lorem Ipsum","Epsom donor","seta met donor Amet","Lorem Ipsum Consector Amet","Other"]
    var selectedindexpath:IndexPath?
    @IBOutlet weak var reportViewHeight: NSLayoutConstraint!
    var issueStr = ""
    @IBOutlet weak var reasonTextView: UITextView!
    var placeholderText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        placeholderText = "Please specify the reason…"
        reasonTextView.text = placeholderText
        // Do any additional setup after loading the view.
        reportViewHeight.constant = 400
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = nil
            //textView.textColor = UIColor.black
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            //textView.textColor = UIColor.lightGray
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func removeViewAction(_ sender: UIButton) {
        
        if issueStr == "" {
            showSnackBarAlert(messageStr: "Please select issue")
        }else if issueStr == "Other" && reasonTextView.text == "Please specify the reason…" {
            showSnackBarAlert(messageStr: "Please Enter your reason")
        }else{
            let reportDict:[String: Any] = ["comment": reasonTextView.text ?? "","issue": issueStr]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeReportView"), object: nil, userInfo: reportDict)
        }
        
        
        
    }
    
    @IBAction func crossBtnAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeReportView"), object: nil, userInfo: nil)
        
    }

}

//MARK: - Tableview Delegate and Datasource -
extension ReportIssueVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return reasonOptionArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = optionTable.dequeueReusableCell(withIdentifier: "ReportViewCell", for: indexPath) as! ReportViewCell
        cell.reasonLable.text = reasonOptionArray[indexPath.row]
        if selectedindexpath  == indexPath {
            cell.selectBtn.isSelected = true
        }else{
            cell.selectBtn.isSelected = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedindexpath = indexPath
        issueStr = reasonOptionArray[indexPath.row]
        if indexPath.row == 4 {
            reportViewHeight.constant = 500
        }else{
            reportViewHeight.constant = 400
            self.view.endEditing(true)
        }
        optionTable.reloadData()
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 44
//    }
    
}

//MARK: - Private Functions -
private extension ReportIssueVC {
    func registerCell() {
        optionTable.register(UINib(nibName: "ReportViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ReportViewCell")
    }
    
}
