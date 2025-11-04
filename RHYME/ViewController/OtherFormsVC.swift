//
//  OtherFormsVC.swift
//  RHYME
//
//  Created by Silstone on 19/10/21.
//

import UIKit

class OtherFormsVC: UIViewController {

    @IBOutlet weak var formTable: UITableView!
    var associatedFormsArray = [NSDictionary]()
    var projectDict = NSDictionary()
    var projectName = "testProject"
    override func viewDidLoad() {
        super.viewDidLoad()
         registerCell()
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
    @IBAction func backBtnAction(_ sender: UIButton) {
    
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - Tableview Delegate and Datasource -
extension OtherFormsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return associatedFormsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = formTable.dequeueReusableCell(withIdentifier: "OtherFormsCell", for: indexPath) as! OtherFormsCell
//        cell.projectNameLable.text = self.projectName
        cell.formNameLable.text = "FLHA"
        let formDict = associatedFormsArray[indexPath.row]
        let formStatus = formDict["task_status"] as? String
        cell.projectNameLable.text = formDict["title"] as? String
        if formStatus == "2" {
            cell.pendingView.isHidden = true
        }else{
            if formStatus == "1" {
                cell.formStatus.text = "Incomplete"
            }else{
                cell.formStatus.text = "Pending"
            }
            cell.pendingView.isHidden = false
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //PushTo(FromVC: self, ToStoryboardID: "TaskDetailsVC")
        let formDict = associatedFormsArray[indexPath.row]
        let formStatus = formDict["task_status"] as? String
        if formStatus == "0" {
            let VC = self.storyboard?.instantiateViewController(identifier: "FLHAVC") as! FLHAVC
            VC.FLHAformInfoDict = projectDict
            VC.isFromProjectVC = true
            VC.taskId = associatedFormsArray[indexPath.row]["id"] as? Int64
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
    }
    
}

//MARK: - Private Functions -
private extension OtherFormsVC {
    func registerCell() {
        formTable.register(UINib(nibName: "OtherFormsCell", bundle: Bundle.main), forCellReuseIdentifier: "OtherFormsCell")
    }
    
}

