//
//  AssetsCell.swift
//  RHYME
//
//  Created by Silstone on 13/10/21.
//

import UIKit

class AssetsCell: UITableViewCell {

    @IBOutlet weak var returnAssetView: UIView!
    @IBOutlet weak var returnAssetButton: UIButton!
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
