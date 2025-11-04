//
//  FormCell.swift
//  RHYME
//
//  Created by Silstone on 14/10/21.
//

import UIKit

class FormCell: UITableViewCell {

    @IBOutlet weak var formTypeLable: UILabel!
    @IBOutlet weak var projectNameLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
