//
//  TaskHazardVC.swift
//  RHYME
//
//  Created by Silstone on 17/11/21.
//

import UIKit

protocol PassHazardDelegate {
    func PassHazardSet(HazardSet: Set<NSDictionary>)
}

class TaskHazardVC: UIViewController {
    var hiddenSections = Set<Int>()
    var tableViewData = [[String:Any]]()
    var selectedValueSet = Set<NSDictionary>()
    var delegate: PassHazardDelegate!
    
    @IBOutlet weak var taskHazardtable: UITableView!
    
    let Array_text = ["A1", "A2", "A3"]
    var selectedindexpath:IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
         registerCell()
        // Do any additional setup after loading the view.
        print("hazardsArray-",_APP_MANAGER.hazardsArray)
        tableViewData = _APP_MANAGER.hazardsArray as! [[String : Any]]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func cancelTaskAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addHazardTaskAction(_ sender: UIButton) {
        if selectedValueSet.count == 0 {
            showSnackBarAlert(messageStr: "Please select hazards.")
        }else{
            self.delegate.PassHazardSet(HazardSet: selectedValueSet)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    @objc
    private func hideSection(sender: UIButton) {
        let section = sender.tag

        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()
            
            //vinay here-
            let values = self.tableViewData[section]["values"] as? NSArray
            
            for row in 0..<values!.count {
                indexPaths.append(IndexPath(row: row,
                                            section: section))
            }
            
            return indexPaths
        }
        
        if self.hiddenSections.contains(section) {
            print("contains")
            sender.isSelected = false
            self.hiddenSections.remove(section)
            self.taskHazardtable.insertRows(at: indexPathsForSection(),
                                      with: .fade)
        } else {
            print("not contains")
            sender.isSelected = true
            self.hiddenSections.insert(section)
            self.taskHazardtable.deleteRows(at: indexPathsForSection(),
                                      with: .fade)
        }
    }
    @objc func showTaskImages() {
       PushTo(FromVC: self, ToStoryboardID: "ProjectImagesVC")
    }
}

extension TaskHazardVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hiddenSections.contains(section) {
            return 0
        }
        let values = self.tableViewData[section]["values"] as? NSArray
        return values!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = taskHazardtable.dequeueReusableCell(withIdentifier: "TaskHazardCell", for: indexPath) as! TaskHazardCell
        let values = self.tableViewData[indexPath.section]["values"] as? NSArray
        let valueDict = values![indexPath.row] as? NSDictionary
        cell.hazardLable.text = valueDict!["name"] as? String
        if selectedValueSet.contains(valueDict!){
            cell.selectBtn.isSelected = true
        }else{
            cell.selectBtn.isSelected = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = Bundle.main.loadNibNamed("HazardSectionView", owner: self, options: nil)?.first as? HazardSectionView
        headerCell?.hazardName.text = self.tableViewData[section]["catName"] as? String
        if self.hiddenSections.contains(section){
            headerCell?.touchBtn.isSelected = true
        }else{
            headerCell?.touchBtn.isSelected = false
        }
        headerCell?.touchBtn.tag = section
        //headerCell?.touchBtn.addTarget(self, action: #selector(showTaskImages), for: .touchUpInside)
        headerCell?.touchBtn.addTarget(self, action: #selector(self.hideSection(sender:)), for: .touchUpInside)
        return headerCell
//        let sectionButton = UIButton()
//        sectionButton.setTitle("Environmental Hazards",
//                               for: .normal)
//        sectionButton.backgroundColor = .systemBlue
//        sectionButton.tag = section
//        sectionButton.addTarget(self,
//                                action: #selector(self.hideSection(sender:)),
//                                for: .touchUpInside)
//        headerCell?.addSubview(sectionButton)
//
//        return sectionButton
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let values = self.tableViewData[indexPath.section]["values"] as? NSArray
        let valueDict = values![indexPath.row] as? NSDictionary
        if !selectedValueSet.contains(valueDict!){
            selectedValueSet.insert(valueDict!)
        }else{
            selectedValueSet.remove(valueDict!)
        }
        print("selected-",selectedValueSet)
//        self.selectedindexpath = indexPath
        tableView.reloadData()
    }
}

//MARK: - Private Functions -
private extension TaskHazardVC {
    func registerCell() {
        taskHazardtable.register(UINib(nibName: "TaskHazardCell", bundle: Bundle.main), forCellReuseIdentifier: "TaskHazardCell")
    }
    
}
