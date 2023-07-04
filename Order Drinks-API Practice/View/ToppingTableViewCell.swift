//
//  ToppingTableViewCell.swift
//  LiHoTea
//
//  Created by Ryan Lin on 2023/6/5.
//

import UIKit

class ToppingTableViewCell: UITableViewCell {

    @IBOutlet weak var toppingTextField: UITextField!
    
    @IBOutlet weak var toppingPriceTextField: UITextField!
    
    @IBOutlet weak var checkButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
