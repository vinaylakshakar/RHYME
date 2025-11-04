//
//  TasksVC.swift
//  RHYME
//
//  Created by Silstone on 15/11/21.
//

import UIKit

class TasksVC: UIViewController,PassHazardTaskDelegate {
    
    @IBOutlet weak var tasksTable: UITableView!
    var tasksArray = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        // Do any additional setup after loading the view.
        //tasksTable.isHidden = true
    }
    
    func PassHazardTaskDict(HazardTask: NSDictionary) {
        print("HazardTask-",HazardTask)
        tasksArray.append(HazardTask)
        tasksTable.isHidden = false
        tasksTable.reloadData()
    }
    
    func PassEditHazardTaskDict(HazardTask: NSDictionary, index: Int) {
        tasksArray.remove(at: index)
        tasksArray.insert(HazardTask, at: index)
        tasksTable.isHidden = false
        tasksTable.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func addTaskAction(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(identifier: "NewTaskVC") as! NewTaskVC
        vc.modalPresentationStyle = . fullScreen
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        
        if tasksArray.count == 0  {
            self.showSnackBarAlert(messageStr: "Please Create Task.")
            
        }else{
            setTaskArray()
            let vc = self.storyboard?.instantiateViewController(identifier: "TaskQuestionsVC") as! TaskQuestionsVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func setTaskArray()  {
        
        var tasksProjectArray = [NSDictionary]()
        for Dict in tasksArray {
            
            var taskDict = [String:Any]()
            taskDict["name"] = Dict["Task"] as? String
            let hazardsArray = Dict["Hazards"] as? Array<[String:Any]>
            var commaSeparatedArray = [String]()
            for Dict in hazardsArray! {
                let ids = Dict["id"] as? Int
                commaSeparatedArray.append("\(String(describing: ids!))")
            }
            taskDict["hazards"] = commaSeparatedArray.joined(separator: ", ")
            taskDict["plan"] = Dict["Plans to eliminate/control"] as? String
            taskDict["probability"] = Dict["probability"] as? String
            taskDict["severity"] = Dict["severity"] as? String
            tasksProjectArray.append(taskDict as NSDictionary)
        }
        
        _APP_MANAGER.saveLFHAProjectTask(tasksProjectArray as NSArray)
    }
    
    @objc func editTaskItem(sender:UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionEdit = UIAlertAction(title: "Edit", style: .default) {
            UIAlertAction in
            // Write your code here
            let vc = self.storyboard?.instantiateViewController(identifier: "NewTaskVC") as! NewTaskVC
            vc.isEditTask = true
            vc.editDictionary = self.tasksArray[sender.tag] as! [String : Any]
            vc.editIndex = sender.tag
            vc.delegate = self
            vc.modalPresentationStyle = . fullScreen
            self.present(vc, animated: true, completion: nil)
            print("Edit clicked")
        }
        alert.addAction(actionEdit)
        let action = UIAlertAction(title: "Delete", style: .destructive) {
            UIAlertAction in
            // Write your code here
            self.tasksArray.remove(at: sender.tag)
            self.tasksTable.reloadData()
            
            if self.tasksArray.count == 0{
                self.tasksTable.isHidden = true
            }
        }
        alert.addAction(action)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
            // It will dismiss action sheet
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getSeverityStr(severity:String) -> String {
        switch severity {
        case "1":
            return "Imminent Danger"
        case "2":
            return "Serious"
        case "3":
            return "Minor"
        case "4":
            return "NA"
        default:
            return ""
        }
    }
    
    func getProbabilityStr(probability:String) -> String {
        switch probability {
        case "A":
            return "Probable"
        case "B":
            return "Reasonably Probable"
        case "C":
            return "Remote"
        case "D":
            return "Extremely Remote"
        default:
            return ""
        }
    }

}
//MARK: - Tableview Delegate and Datasource -
extension TasksVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasksArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tasksTable.dequeueReusableCell(withIdentifier: "FLHATasksCell", for: indexPath) as! FLHATasksCell
        
        let taskDict = tasksArray[indexPath.row]
        cell.taskNameLable.text = taskDict["Task"] as? String
        cell.eliminatePlanLable.text = taskDict["Plans to eliminate/control"] as? String
        let severityStr = taskDict["severity"] as? String
        let probabilityStr = taskDict["probability"] as? String
        
        let priorityStr = severityStr! + probabilityStr! + " (\(self.getSeverityStr(severity: severityStr!)) + \(self.getProbabilityStr(probability: probabilityStr!)))"
        print("priorityStr-",priorityStr)
        cell.priorityLable.text = priorityStr
        let hazardsArray = taskDict["Hazards"] as? Array<[String:Any]>
        var commaSeparatedArray = [String]()
        for Dict in hazardsArray! {
            let name = Dict["name"] as? String
            commaSeparatedArray.append(name!)
        }
        print("hazardsArray-",commaSeparatedArray)
        cell.taskHazarsLable.text = commaSeparatedArray.joined(separator: ", ")
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(editTaskItem(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 234
    }
    
}

//MARK: - Private Functions -
private extension TasksVC {
    func registerCell() {
        tasksTable.register(UINib(nibName: "FLHATasksCell", bundle: Bundle.main), forCellReuseIdentifier: "FLHATasksCell")
    }
    
}
