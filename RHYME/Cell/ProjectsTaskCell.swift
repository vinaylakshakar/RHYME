//
//  ProjectsTaskCell.swift
//  RHYME
//
//  Created by Silstone on 19/10/21.
//

import UIKit

class ProjectsTaskCell: UITableViewCell {
    
    @IBOutlet weak var taskNameLable: UILabel!
    @IBOutlet weak var taskEnd_date: UILabel!
    @IBOutlet weak var taskEnd_month: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
