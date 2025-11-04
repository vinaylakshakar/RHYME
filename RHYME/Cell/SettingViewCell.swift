//
//  SettingViewCell.swift
//  RHYME
//
//  Created by Silstone on 15/11/21.
//

import UIKit

class SettingViewCell: UITableViewCell {

    @IBOutlet weak var emailField: UILabel!
    @IBOutlet weak var userEmailField: UILabel!
    @IBOutlet weak var userNameField: UILabel!
    @IBOutlet weak var designationField: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
