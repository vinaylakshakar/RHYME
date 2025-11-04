//
//  DocumentCell.swift
//  RHYME
//
//  Created by Silstone on 11/10/21.
//

import UIKit

class DocumentCell: UITableViewCell {

    @IBOutlet weak var documentImage: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var documentType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
