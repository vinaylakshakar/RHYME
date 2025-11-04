//
//  ProjectsVC.swift
//  RHYME
//
//  Created by Silstone on 19/10/21.
//

import UIKit
import iProgressHUD
import Alamofire

class ProjectsVC: UIViewController {

    @IBOutlet weak var projectTable: UITableView!
    @IBOutlet weak var projectCollection: UICollectionView!
    var netwoking = NetworkApi()
    var allProjectArray = [NSDictionary]()
    var taskCollectionType = ["Due this Week","Pending","Completed"]
    var selectedIndexPath:IndexPath?
    var dueThisWeekProjectTaskArray = [NSDictionary]()
    var pendingProjectTaskArray = [NSDictionary]()
    var completedProjectTaskArray = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupProgressHud(view: view)
        registerCell()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedIndexPath = nil
        getProjectList()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func convertStrToDate(isoDate:String) -> Date {
        //let isoDate = "2016-04-14T10:44:00+0000"

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:isoDate)!
        return date
    }
    
    func filterPendingProjectTaskArray(ProjectTaskArray:[NSDictionary]) {
        pendingProjectTaskArray.removeAll()
        for projectDict in ProjectTaskArray {
            var filterProjectDict = projectDict as? [String:Any]
            var pendingTaskArray = [NSDictionary]()

            let taskArray = projectDict["tasks"] as! [NSDictionary]
            for taskDetailDict in taskArray {
                let task_status = taskDetailDict["task_status"] as? String
                if task_status == "0" || task_status == "1"{
                    pendingTaskArray.append(taskDetailDict)
                }
            }
            
            if pendingTaskArray.count>0 {
                filterProjectDict!["tasks"] = pendingTaskArray
                pendingProjectTaskArray.append(filterProjectDict! as NSDictionary)
            }
            
        }

        self.projectTable.reloadData()
        projectCollection.reloadData()
        
    }
    
    func filterCompletedProjectTaskArray(ProjectTaskArray:[NSDictionary]) {
        completedProjectTaskArray.removeAll()
        for projectDict in ProjectTaskArray {
            var filterProjectDict = projectDict as? [String:Any]
            var completedTaskArray = [NSDictionary]()
            let taskArray = projectDict["tasks"] as! [NSDictionary]
            
            for taskDetailDict in taskArray {
                let task_status = taskDetailDict["task_status"] as? String
                if task_status == "2" {
                    completedTaskArray.append(taskDetailDict)
                }
            }
            if completedTaskArray.count>0 {
                filterProjectDict!["tasks"] = completedTaskArray
                completedProjectTaskArray.append(filterProjectDict! as NSDictionary)
            }
            
            print(completedProjectTaskArray.count)
        }

        self.projectTable.reloadData()
        projectCollection.reloadData()
        
    }
    
    func filterDueThisWeekProjectTaskArray(ProjectTaskArray:[NSDictionary]) {
        dueThisWeekProjectTaskArray.removeAll()
        for projectDict in ProjectTaskArray {
            var filterProjectDict = projectDict as? [String:Any]
            var dueThisWeekTaskArray = [NSDictionary]()
            let taskArray = projectDict["tasks"] as! [NSDictionary]
            
            for taskDetailDict in taskArray {
                let task_status = taskDetailDict["task_status"] as? String
                if task_status == "0" || task_status == "1" {
                    if let end_date = taskDetailDict["end_date"] as? String{
                        let taskEndDate = convertStrToDate(isoDate: end_date)
                        
                        if Date().endOfWeek! >= taskEndDate {
                            dueThisWeekTaskArray.append(taskDetailDict)
                        }
                    }
                   // dueThisWeekTaskArray.append(taskDetailDict)
                }
            }
            
            if dueThisWeekTaskArray.count>0 {
                filterProjectDict!["tasks"] = dueThisWeekTaskArray
                dueThisWeekProjectTaskArray.append(filterProjectDict! as NSDictionary)
            }
            
            print(dueThisWeekProjectTaskArray.count)
            allProjectArray = dueThisWeekProjectTaskArray
        }

        self.projectTable.reloadData()
        projectCollection.reloadData()
        
    }
    
    // MARK: - Api methods
    func getProjectList() {
        pendingProjectTaskArray.removeAll()
        completedProjectTaskArray.removeAll()
        dueThisWeekProjectTaskArray.removeAll()
        
        view.showProgress()
        let header: HTTPHeaders = [
            
            "Authorization" : "Token " + _APP_MANAGER.userAuthorizationToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        netwoking.getProject(apiMethod: "", parameters: "", headers: header) { [self] (response) in
            self.view.dismissProgress()
            switch response.result {
                    
                        case .success(_):
                    print(response.result.value as Any )
            
                    if let dic =  response.result.value as? [String : Any]{
                        

                        if let responseArray = dic["data"] as? NSArray {
                            print("data-",responseArray)
                            let projectTaskArray = responseArray as! [NSDictionary]
                            //self.dueThisWeekProjectTaskArray = self.allProjectArray
//                            self.projectTable.reloadData()
//                            projectCollection.reloadData()
                            filterPendingProjectTaskArray(ProjectTaskArray: projectTaskArray)
                            filterCompletedProjectTaskArray(ProjectTaskArray: projectTaskArray)
                            filterDueThisWeekProjectTaskArray(ProjectTaskArray: projectTaskArray)
                            
                        }
                   
                    
                   
                }  else {
                        
                                
                        }
                
                
                case .failure(let error):
                print(error)
                            
                break
            }
        }
    }

}

extension ProjectsVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
            cell.formNumberLabel.text = _APP_MANAGER.dueThisWeekTaskCount
        }
        if indexPath.row == 1 {
            cell.formNumberLabel.text = _APP_MANAGER.pendingTaskCount
        }
        if indexPath.row == 2 {
            cell.formNumberLabel.text = _APP_MANAGER.completedTaskCount
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        if indexPath.row == 0 {
            allProjectArray = self.dueThisWeekProjectTaskArray
        }
        if indexPath.row == 1 {
            allProjectArray = self.pendingProjectTaskArray
        }
        if indexPath.row == 2 {
            allProjectArray = self.completedProjectTaskArray
        }
        collectionView.reloadData()
        projectTable.reloadData()
       // PushTo(FromVC: self, ToStoryboardID: "ManteePostDetail")
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let collectionViewWidth = collectionView.bounds.size.width
        
        return CGSize(width: 105, height: 67)
    }
    
    @objc func showTaskImages(sender:UIButton) {
       //PushTo(FromVC: self, ToStoryboardID: "ProjectImagesVC")
        let VC = self.storyboard?.instantiateViewController(identifier: "ProjectImagesVC") as! ProjectImagesVC
        let projectDict = allProjectArray[sender.tag]
        VC.tasksArray = projectDict["tasks"] as! [NSDictionary]
        VC.projectNameStr = projectDict["name"] as! String
        self.navigationController?.pushViewController(VC, animated: false)
    }
    
    @objc func showFormsStatus(sender:UIButton) {
       //PushTo(FromVC: self, ToStoryboardID: "ProjectImagesVC")
        let VC = self.storyboard?.instantiateViewController(identifier: "OtherFormsVC") as! OtherFormsVC
        let projectDict = allProjectArray[sender.tag]
        VC.projectDict = projectDict
        VC.projectName = projectDict["name"] as! String
        VC.associatedFormsArray = projectDict["forms"] as! [NSDictionary]
        self.navigationController?.pushViewController(VC, animated: true)
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
}

//MARK: - Tableview Delegate and Datasource -
extension ProjectsVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        allProjectArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell1 = Bundle.main.loadNibNamed("ProjectSectionView", owner: self, options: nil)?.first as? ProjectSectionView
        let projectDict = allProjectArray[section]
        headerCell1?.projectNameLable.text = projectDict["name"] as? String
        headerCell1?.projectDescription.text = projectDict["description"] as? String
        let formsArray = allProjectArray[section]["forms"] as! NSArray
        headerCell1?.numberOfForms.text = "\(String(describing: formsArray.count))"
        
        let tasksArray = allProjectArray[section]["tasks"] as! NSArray
        if tasksArray.count > 3 {
            headerCell1?.leftImageLable.text = "+\(tasksArray.count - 3)"
            let ItemDict1 =  tasksArray[0] as? [String:Any]
            if let urlStr1 = ItemDict1!["img_url"] as? String {
                headerCell1?.firstImageView.sd_setImage(with: URL(string: urlStr1), placeholderImage:UIImage(named: "Rectangle 2452"))
            }
            let ItemDict2 =  tasksArray[1] as? [String:Any]
            if let urlStr2 = ItemDict2!["img_url"] as? String {
                headerCell1?.secondImageView.sd_setImage(with: URL(string: urlStr2), placeholderImage:UIImage(named: "Rectangle 2452"))
            }
            let ItemDict3 =  tasksArray[2] as? [String:Any]
            if let urlStr3 = ItemDict3!["img_url"] as? String {
                headerCell1?.thirdImageView.sd_setImage(with: URL(string: urlStr3), placeholderImage:UIImage(named: "Rectangle 2452"))
            }
        }else{
            headerCell1?.leftImageLable.text = ""
            if tasksArray.count>0 {
                let ItemDict =  tasksArray[0] as? [String:Any]
                if let urlStr = ItemDict!["img_url"] as? String {
                    headerCell1?.firstImageView.sd_setImage(with: URL(string: urlStr), placeholderImage:UIImage(named: "Rectangle 2452"))
                }
            }
            if tasksArray.count>1 {
                let ItemDict =  tasksArray[1] as? [String:Any]
                if let urlStr = ItemDict!["img_url"] as? String {
                    headerCell1?.secondImageView.sd_setImage(with: URL(string: urlStr), placeholderImage:UIImage(named: "Rectangle 2452"))
                }
            }
            if tasksArray.count>2 {
                let ItemDict =  tasksArray[2] as? [String:Any]
                if let urlStr = ItemDict!["img_url"] as? String {
                    headerCell1?.thirdImageView.sd_setImage(with: URL(string: urlStr), placeholderImage:UIImage(named: "Rectangle 2452"))
                }
            }
        }
        
        headerCell1?.projectImagesBtn.tag = section
        headerCell1?.projectImagesBtn.addTarget(self, action: #selector(showTaskImages), for: .touchUpInside)
        headerCell1?.formBtn.tag = section
        headerCell1?.formBtn.addTarget(self, action: #selector(showFormsStatus), for: .touchUpInside)
        return headerCell1

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 173
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let taskArray = allProjectArray[section]["tasks"] as? NSArray
        return taskArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = projectTable.dequeueReusableCell(withIdentifier: "ProjectsTaskCell", for: indexPath) as! ProjectsTaskCell
        let taskArray = allProjectArray[indexPath.section]["tasks"] as? NSArray
        let taskDict = taskArray![indexPath.row] as? NSDictionary
        cell.taskNameLable.text = taskDict!["title"] as? String
        if let dateStr = taskDict!["end_date"] as? String {
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
        let taskArray = allProjectArray[indexPath.section]["tasks"] as? NSArray
        let taskDict = taskArray![indexPath.row]
        VC.taskDetailDict = taskDict as! NSDictionary
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
}

//MARK: - Private Functions -
private extension ProjectsVC {
    func registerCell() {
        projectTable.register(UINib(nibName: "ProjectsTaskCell", bundle: Bundle.main), forCellReuseIdentifier: "ProjectsTaskCell")
        projectCollection.register(UINib(nibName: "CollectionFromCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CollectionFromCell")
    }
    
}
