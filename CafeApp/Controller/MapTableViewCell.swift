//
//  MapTableViewCell.swift
//  CafeApp
//
//  Created by Machir on 2022/9/27.
//

import UIKit

class MapTableViewCell: UITableViewCell {

    @IBOutlet weak var storeWifiLabel: UILabel!
    @IBOutlet weak var storeSeatLabel: UILabel!
    @IBOutlet weak var storeQuietLabel: UILabel!
    @IBOutlet weak var storeTastyLabel: UILabel!
    @IBOutlet weak var storeCheapLabel: UILabel!
    @IBOutlet weak var storeMusicLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
