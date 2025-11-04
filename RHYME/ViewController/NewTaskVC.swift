//
//  NewTaskVC.swift
//  RHYME
//
//  Created by Silstone on 16/11/21.
//

import UIKit

protocol PassHazardTaskDelegate {
    func PassHazardTaskDict(HazardTask: NSDictionary)
    func PassEditHazardTaskDict(HazardTask: NSDictionary,index: Int)
}

class NewTaskVC: UIViewController,PassHazardDelegate {
   
    

    @IBOutlet weak var tagHazardCollectionview: UICollectionView!
    var hazardTagArray = [NSDictionary]()
    var selectedhazardSet = Set<NSDictionary>()
    @IBOutlet weak var hazardHeightConstraint: NSLayoutConstraint!
    var severityStr = ""
    var probabilityStr = ""
    var delegate: PassHazardTaskDelegate!
    @IBOutlet weak var taskHazardNameField: UITextField!
    @IBOutlet weak var eliminatePlanField: UITextField!
    var isEditTask = false
    var editIndex:Int?
    var editDictionary = [String: Any]()
    @IBOutlet weak var probabilityPopupView: UIView!
    @IBOutlet weak var severityPopupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       registerCell()
        // Do any additional setup after loading the view.
        //hazardHeightConstraint.constant = 200
        self.hazardHeightConstraint.constant = self.tagHazardCollectionview.contentSize.height;
       // hazardTagArray = ["Dust / Mist/ Fumes","Spill Potential","Other Workers in Area"]
        if isEditTask {
            setLayout()
        }
    }
    
    func setLayout() {
        severityStr = editDictionary["severity"] as! String
        setSeverity(severity: severityStr)
        probabilityStr = editDictionary["probability"] as! String
        setProbability(probability: probabilityStr)
        taskHazardNameField.text = editDictionary["Task"] as? String
        eliminatePlanField.text = editDictionary["Plans to eliminate/control"] as? String
        let HazardsArray = editDictionary["Hazards"] as? Array<[String:Any]>
        selectedhazardSet = NSSet(array: HazardsArray!) as! Set<NSDictionary>
        hazardTagArray = Array(selectedhazardSet)
        tagHazardCollectionview.reloadData()
        self.hazardHeightConstraint.constant = 98
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
               //call any function
            let height = self.tagHazardCollectionview.collectionViewLayout.collectionViewContentSize.height
            self.hazardHeightConstraint.constant = height
            self.view.layoutIfNeeded()
        }
//            let HazardsArray = Array(selectedhazardSet)
//            hazardTaskDict["Hazards"]  = HazardsArray
    }
    
    func setSeverity(severity:String) {
        switch severity {
        case "1":
            let button = self.view.viewWithTag(11) as? UIButton
            button!.imageEdgeInsets = UIEdgeInsets(top: -2, left: 10, bottom: 40, right: 95)
            button?.isSelected = true
        case "2":
            let button = self.view.viewWithTag(12) as? UIButton
            button!.imageEdgeInsets = UIEdgeInsets(top: -2, left: 10, bottom: 40, right: 95)
            button?.isSelected = true
        case "3":
            let button = self.view.viewWithTag(13) as? UIButton
            button!.imageEdgeInsets = UIEdgeInsets(top: -2, left: 10, bottom: 40, right: 95)
            button?.isSelected = true
        case "4":
            let button = self.view.viewWithTag(14) as? UIButton
            button!.imageEdgeInsets = UIEdgeInsets(top: -2, left: 10, bottom: 40, right: 95)
            button?.isSelected = true
        default:
            return
        }
    }
    
    func setProbability(probability:String) {
        switch probability {
        case "A":
            let button = self.view.viewWithTag(21) as? UIButton
            button!.imageEdgeInsets = UIEdgeInsets(top: -2, left: 10, bottom: 40, right: 95)
            button?.isSelected = true
        case "B":
            let button = self.view.viewWithTag(22) as? UIButton
            button!.imageEdgeInsets = UIEdgeInsets(top: -2, left: 10, bottom: 40, right: 95)
            button?.isSelected = true
        case "C":
            let button = self.view.viewWithTag(23) as? UIButton
            button!.imageEdgeInsets = UIEdgeInsets(top: -2, left: 10, bottom: 40, right: 95)
            button?.isSelected = true
        case "D":
            let button = self.view.viewWithTag(24) as? UIButton
            button!.imageEdgeInsets = UIEdgeInsets(top: -2, left: 10, bottom: 40, right: 95)
            button?.isSelected = true
        default:
            return
        }
    }
    
    @IBAction func selectSeverityAction(_ sender: UIButton) {
        let itemArray = [11,12,13,14]
        for tag in itemArray {
            let button = self.view.viewWithTag(tag) as? UIButton
            button!.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 42, right: 93)
            button?.isSelected = false
            let label = self.view.viewWithTag(tag+4) as? UILabel
            label?.textColor = UIColor(red: 0.48, green: 0.48, blue: 0.48, alpha: 1.00)
        }
        
        sender.isSelected = true
        let button = self.view.viewWithTag(sender.tag) as? UIButton
        button!.imageEdgeInsets = UIEdgeInsets(top: -2, left: 10, bottom: 40, right: 95)
        let label = self.view.viewWithTag(sender.tag+4) as? UILabel
        label?.textColor = UIColor(red: 0.08, green: 0.23, blue: 1.00, alpha: 1.00)
        
        switch sender.tag {
        case 11:
            severityStr = "1"
        case 12:
            severityStr = "2"
        case 13:
            severityStr = "3"
        case 14:
            severityStr = "4"
        default:
            return
        }
    }
    
    @IBAction func selectProbabilityAction(_ sender: UIButton) {
        let itemArray = [21,22,23,24]
        for tag in itemArray {
            let button = self.view.viewWithTag(tag) as? UIButton
            button!.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 42, right: 93)
            button?.isSelected = false
            let label = self.view.viewWithTag(tag+4) as? UILabel
            label?.textColor = UIColor(red: 0.48, green: 0.48, blue: 0.48, alpha: 1.00)
        }
        
        sender.isSelected = true
        let button = self.view.viewWithTag(sender.tag) as? UIButton
        button!.imageEdgeInsets = UIEdgeInsets(top: -2, left: 10, bottom: 40, right: 95)
        let label = self.view.viewWithTag(sender.tag+4) as? UILabel
        label?.textColor = UIColor(red: 0.08, green: 0.23, blue: 1.00, alpha: 1.00)
        
        switch sender.tag {
        case 21:
            probabilityStr = "A"
        case 22:
            probabilityStr = "B"
        case 23:
            probabilityStr = "C"
        case 24:
            probabilityStr = "D"
        default:
            return
        }
    }
    
    
    func PassHazardSet(HazardSet: Set<NSDictionary>) {
        selectedhazardSet.removeAll()
        for itemDict in HazardSet {
            selectedhazardSet.insert(itemDict)
        }
        hazardTagArray = Array(selectedhazardSet)
        setCollectionLayout()
  
    }
    
    func setCollectionLayout() {
        tagHazardCollectionview.reloadData()
        self.hazardHeightConstraint.constant = 98
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
               //call any function
            let height = self.tagHazardCollectionview.collectionViewLayout.collectionViewContentSize.height
            self.hazardHeightConstraint.constant = height
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func probabilityAction(_ sender: UIButton) {
        
        if probabilityPopupView.isHidden {
            probabilityPopupView.isHidden = false
        }else{
            probabilityPopupView.isHidden = true
        }
    }
    
    @IBAction func severityAction(_ sender: UIButton) {
        
        if severityPopupView.isHidden {
            severityPopupView.isHidden = false
        }else{
            severityPopupView.isHidden = true
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
    
    @IBAction func addHazardAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "TaskHazardVC") as! TaskHazardVC
        vc.modalPresentationStyle = . fullScreen
        vc.delegate = self
        vc.selectedValueSet = selectedhazardSet
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelTaskAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTaskAction(_ sender: UIButton) {
        if taskHazardNameField.text == "" {
            showSnackBarAlert(messageStr: "Please select Task Name")
        }else
        if selectedhazardSet.count == 0 {
            showSnackBarAlert(messageStr: "Please select Hazards")
        }else
        if severityStr == "" || probabilityStr == "" {
            showSnackBarAlert(messageStr: "Please select Severity and Probability")
        }else
        if eliminatePlanField.text == "" {
            showSnackBarAlert(messageStr: "Please enter control")
        }else{
//            let priorityStr = severityStr + probabilityStr + " (\(self.getSeverityStr(severity: severityStr)) + \(self.getProbabilityStr(probability: probabilityStr)))"
//            print("priorityStr-",priorityStr)
            
            var hazardTaskDict = [String: Any]()
            hazardTaskDict["severity"] = severityStr
            hazardTaskDict["probability"] = probabilityStr
            hazardTaskDict["Task"]  = taskHazardNameField.text
            hazardTaskDict["Plans to eliminate/control"]  = eliminatePlanField.text
            let HazardsArray = Array(selectedhazardSet)
            hazardTaskDict["Hazards"]  = HazardsArray
            
            if isEditTask {
                self.delegate.PassEditHazardTaskDict(HazardTask: hazardTaskDict as NSDictionary, index: editIndex!)
            }else{
                self.delegate.PassHazardTaskDict(HazardTask: hazardTaskDict as NSDictionary)
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    func estimatedFrame(text: String, font: UIFont) -> CGRect {
        let size = CGSize(width: 200, height: 1000) // temporary size
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [NSAttributedString.Key.font: font],
                                                   context: nil)
    }
    
    

}

extension NewTaskVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hazardTagArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagHazardViewCell", for: indexPath) as! tagHazardViewCell
        let Dict = hazardTagArray[indexPath.row]
        cell.tagLable.text = Dict["name"] as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // PushTo(FromVC: self, ToStoryboardID: "ManteePostDetail")
        hazardTagArray.remove(at: indexPath.row)
        selectedhazardSet = NSSet(array: hazardTagArray) as! Set<NSDictionary>
        tagHazardCollectionview.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
               //call any function
            let height = self.tagHazardCollectionview.collectionViewLayout.collectionViewContentSize.height
            self.hazardHeightConstraint.constant = height
            self.view.layoutIfNeeded()
        }
       
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        //let collectionViewWidth = collectionView.bounds.size.width
//        let text = hazardTagArray[indexPath.row]
//        let width = self.estimatedFrame(text: text, font: UIFont(name: "Lato-Regular", size: 12.0)!).width
//        return CGSize(width: width, height: 30.0)
//       // return CGSize(width: 126, height: 30)
//    }
    
}

//MARK: - Private Functions -
private extension NewTaskVC {
    func registerCell() {
        tagHazardCollectionview.register(UINib(nibName: "tagHazardViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "tagHazardViewCell")
    }
    
}
