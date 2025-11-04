//
//  ProjectImagesVC.swift
//  RHYME
//
//  Created by Silstone on 19/10/21.
//

import UIKit

class ProjectImagesVC: UIViewController {

    @IBOutlet weak var taskImageView: UIImageView!
    var tasksArray = [NSDictionary]()
    @IBOutlet weak var imageCountLable: UILabel!
    var imageIndex = 0
    @IBOutlet weak var projectNameLable: UILabel!
    var projectNameStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(tasksArray)
        // Do any additional setup after loading the view.
        setLayput()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeMenuBtn"), object: nil, userInfo: nil)
    }

    func setLayput() {
        let ItemDict =  tasksArray[imageIndex]
        if let urlStr = ItemDict["img_url"] as? String {
            let trimmedString = urlStr.trimmingCharacters(in: .whitespaces)
            taskImageView.sd_setImage(with: URL(string: trimmedString), placeholderImage:nil)
        }
        imageCountLable.text = "Image \(imageIndex+1)/\(tasksArray.count)"
        projectNameLable.text = projectNameStr
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func previousImageAction(_ sender: UIButton) {
        let isIndexValid = tasksArray.indices.contains(imageIndex-1)
        if isIndexValid {
            imageIndex = imageIndex - 1
            setLayput()
        }
    }
    @IBAction func forwordImageAction(_ sender: UIButton) {
        let isIndexValid = tasksArray.indices.contains(imageIndex+1)
        if isIndexValid {
            imageIndex = imageIndex + 1
            setLayput()
        }
    }
    
    @IBAction func crossButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }

}
