//
//  OtherFormsCell.swift
//  RHYME
//
//  Created by Silstone on 19/10/21.
//

import UIKit

class OtherFormsCell: UITableViewCell {

    @IBOutlet weak var pendingView: UIView!
    @IBOutlet weak var signedView: UIView!
    @IBOutlet weak var formNameLable: UILabel!
    @IBOutlet weak var projectNameLable: UILabel!
    @IBOutlet weak var formStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
