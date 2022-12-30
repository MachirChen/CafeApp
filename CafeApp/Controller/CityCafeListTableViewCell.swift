//
//  CityCafeListTableViewCell.swift
//  CafeApp
//
//  Created by Machir on 2022/11/26.
//

import UIKit

class CityCafeListTableViewCell: UITableViewCell {

    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
