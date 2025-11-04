//
//  FLHATasksCell.swift
//  RHYME
//
//  Created by Silstone on 15/11/21.
//

import UIKit

class FLHATasksCell: UITableViewCell {
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var taskNameLable: UILabel!
    @IBOutlet weak var taskHazarsLable: UILabel!
    @IBOutlet weak var priorityLable: UILabel!
    @IBOutlet weak var eliminatePlanLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
