//
//  GroceryItemCell.swift
//  MyFinalExam
//
//  Created by Tarooti on 10/06/1443 AH.
//

import UIKit

class GroceryItemCell: UITableViewCell {

    
    
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var isChecked: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
