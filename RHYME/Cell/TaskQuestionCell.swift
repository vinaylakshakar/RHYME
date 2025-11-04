//
//  TaskQuestionCell.swift
//  RHYME
//
//  Created by Silstone on 22/11/21.
//

import UIKit

class TaskQuestionCell: UITableViewCell {

    @IBOutlet weak var taskQuestionLable: UILabel!
    @IBOutlet weak var explainViewConstant: NSLayoutConstraint!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var explanationField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
