//
//  CafeListTableViewCell.swift
//  CafeApp
//
//  Created by Machir on 2022/8/17.
//

import UIKit

class CafeListTableViewCell: UITableViewCell {

    @IBOutlet weak var cafeNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
