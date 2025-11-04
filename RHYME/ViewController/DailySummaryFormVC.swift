//
//  DailySummaryFormVC.swift
//  RHYME
//
//  Created by Silstone on 15/10/21.
//

import UIKit

class DailySummaryFormVC: UIViewController {

    var productNameArray = ["Drill Machine","Drill Machine 2","Drill Machine 3","Drill Machine 4"]
    @IBOutlet weak var productField: UITextField!
    @IBOutlet weak var forumFieldFirst: UITextField!
    @IBOutlet weak var forumFieldSecod: UITextField!
    @IBOutlet weak var forumFieldThird: UITextField!
    @IBOutlet weak var signedFormView: UIView!
    
    @IBOutlet weak var optionTable: UITableView!
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
    
    @IBAction func selectConditionsButton(_ sender: UIButton) {
        optionTable.isHidden = false
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signFormAction(_ sender: UIButton) {
        self.signedFormView.isHidden = false
    }

}

extension DailySummaryFormVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        cell.textLabel?.text = productNameArray[indexPath.row]
        cell.textLabel?.font = UIFont(name:"Lato-Regular",size:17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        productField.text = productNameArray[indexPath.row]
        optionTable.isHidden = true
        tableView.reloadData()
    }
    
    
}
