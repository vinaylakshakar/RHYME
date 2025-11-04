//
//  MyTaskVC.swift
//  RHYME
//
//  Created by Silstone on 18/10/21.
//

import UIKit
import iProgressHUD
import Alamofire

class MyTaskVC: UIViewController {

    @IBOutlet weak var taskTable: UITableView!
    @IBOutlet weak var taskCollection: UICollectionView!
    var netwoking = NetworkApi()
    var allTasksArray = [NSDictionary]()
    var taskCollectionType = ["Due this Week","Pending","Completed"]
    var selectedIndexPath:IndexPath?
    var dueThisWeekTaskArray = [NSDictionary]()
    var pendingTaskArray = [NSDictionary]()
    var completedTaskArray = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupProgressHud(view: view)
        registerCell()
        // Do any additional setup after loading the view.
//        getTasksList()
    }
    override func viewWillAppear(_ animated: Bool) {
        selectedIndexPath = nil
        getTasksList()
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
    func getTasksList() {
        completedTaskArray.removeAll()
        pendingTaskArray.removeAll()
        dueThisWeekTaskArray.removeAll()
        
        view.showProgress()
        let header: HTTPHeaders = [
            
            "Authorization" : "Token " + _APP_MANAGER.userAuthorizationToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        netwoking.getTask(apiMethod: "", parameters: "", headers: header) { [self] (response) in
            self.view.dismissProgress()
            switch response.result {
                    
                        case .success(_):
                    print(response.result.value as Any )
            
                    if let dic =  response.result.value as? [String : Any]{
                        

                        if let responseArray = dic["data"] as? NSArray {
                            print("data-",responseArray)
                            let taskArray = responseArray as! [NSDictionary]
                            //self.taskTable.reloadData()
                            filterTaskArray(taskArray: taskArray)
                        }
                   
                    
                   
                }  else {
                        
                                
                        }
                
                
                case .failure(let error):
                print(error)
                            
                break
            }
        }
    }
    
    func filterTaskArray(taskArray:[NSDictionary]) {
        
        print("endOfWeek-",Date().endOfWeek!)
        
        for taskDetailDict in taskArray {
            let task_status = taskDetailDict["task_status"] as? String
            if task_status == "0" || task_status == "1" {
                pendingTaskArray.append(taskDetailDict)
                if let end_date = taskDetailDict["end_date"] as? String{
                    let taskEndDate = convertStrToDate(isoDate: end_date)
                    
                    if Date().endOfWeek! >= taskEndDate {
                        dueThisWeekTaskArray.append(taskDetailDict)
                    }
                }
            }
            if task_status == "2" {
                completedTaskArray.append(taskDetailDict)
            }
     
            
        }
    
        _APP_MANAGER.savedueThisWeekTaskCount("\(self.dueThisWeekTaskArray.count)")
        _APP_MANAGER.savePendingTaskCount("\(self.pendingTaskArray.count)")
        _APP_MANAGER.saveCompletedTaskCount("\(self.completedTaskArray.count)")
        allTasksArray = dueThisWeekTaskArray
        taskCollection.reloadData()
        taskTable.reloadData()
        
    }
    
    func convertDateFormaterToMonth(dateStr: String) -> String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormatter.date(from: dateStr)
            dateFormatter.dateFormat = "MMM"
            return  dateFormatter.string(from: date!)

        }
    func convertDateFormaterToDate(dateStr: String) -> String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormatter.date(from: dateStr)
            dateFormatter.dateFormat = "dd"
            return  dateFormatter.string(from: date!)

        }
    
    func convertStrToDate(isoDate:String) -> Date {
        //let isoDate = "2016-04-14T10:44:00+0000"

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:isoDate)!
        return date
    }

}
extension MyTaskVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskCollectionType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionFromCell", for: indexPath) as! CollectionFromCell
        cell.formNameLabel.text = taskCollectionType[indexPath.row]
        if indexPath == selectedIndexPath {
            cell.selectedView.isHidden = false
        }else{
            if selectedIndexPath == nil && indexPath.row == 0{
                cell.selectedView.isHidden = false
            }else{
                cell.selectedView.isHidden = true
            }
            
        }
        
        if indexPath.row == 0 {
            cell.formNumberLabel.text = "\(dueThisWeekTaskArray.count)"
        }
        if indexPath.row == 1 {
            cell.formNumberLabel.text = "\(pendingTaskArray.count)"
        }
        if indexPath.row == 2 {
            cell.formNumberLabel.text = "\(completedTaskArray.count)"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        if indexPath.row == 0 {
            allTasksArray = self.dueThisWeekTaskArray
        }
        if indexPath.row == 1 {
            allTasksArray = self.pendingTaskArray
        }
        if indexPath.row == 2 {
            allTasksArray = self.completedTaskArray
        }
        collectionView.reloadData()
        taskTable.reloadData()
       // PushTo(FromVC: self, ToStoryboardID: "ManteePostDetail")
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let collectionViewWidth = collectionView.bounds.size.width
        
        return CGSize(width: 105, height: 67)
    }
    
}

//MARK: - Tableview Delegate and Datasource -
extension MyTaskVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTasksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskTable.dequeueReusableCell(withIdentifier: "MyTaskCell", for: indexPath) as! MyTaskCell
        let taskDict = allTasksArray[indexPath.row]
        cell.taskNameLable.text = taskDict["title"] as? String
        let projectDict = taskDict["assigned_project"] as? NSDictionary
        cell.projectNameLable.text = projectDict!["name"] as? String
        
        if let dateStr = taskDict["end_date"] as? String {
            cell.taskEnd_date.text = convertDateFormaterToDate(dateStr: dateStr)
            cell.taskEnd_month.text = convertDateFormaterToMonth(dateStr: dateStr)
        }else{
            cell.taskEnd_date.text = "N/A"
            cell.taskEnd_month.text = "N/A"
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //PushTo(FromVC: self, ToStoryboardID: "TaskDetailsVC")
        let VC = self.storyboard?.instantiateViewController(identifier: "TaskDetailsVC") as! TaskDetailsVC
        VC.taskDetailDict = allTasksArray[indexPath.row]
        self.navigationController?.pushViewController(VC, animated: true)
    }
}

//MARK: - Private Functions -
private extension MyTaskVC {
    func registerCell() {
        taskTable.register(UINib(nibName: "MyTaskCell", bundle: Bundle.main), forCellReuseIdentifier: "MyTaskCell")
        taskCollection.register(UINib(nibName: "CollectionFromCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CollectionFromCell")
    }
    
}
extension Date {
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 8, to: sunday)
    }
}
