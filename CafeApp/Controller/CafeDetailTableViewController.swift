//
//  CafeDetailTableViewController.swift
//  CafeApp
//
//  Created by Machir on 2022/8/18.
//

import UIKit

class CafeDetailTableViewController: UITableViewController {
    
    var cafeData: Cafe!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var mrtLabel: UILabel!
    @IBOutlet weak var wifiLabel: UILabel!
    @IBOutlet weak var seatLabel: UILabel!
    @IBOutlet weak var quietLabel: UILabel!
    @IBOutlet weak var tastyLabel: UILabel!
    @IBOutlet weak var cheapLabel: UILabel!
    @IBOutlet weak var musicLabel: UILabel!
    @IBOutlet weak var limitedTimeLabel: UILabel!
    @IBOutlet weak var socketLabel: UILabel!
    @IBOutlet weak var standingDeskLabel: UILabel!
    @IBOutlet weak var officialWebsiteTextView: UITextView!
    @IBOutlet weak var openTimeTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeDisplay()
    }
    
    func changeDisplay() {
        nameLabel.text = cafeData.name
        addressTextView.text = cafeData.address
        mrtLabel.text = cafeData.mrt
        wifiLabel.text = "\(cafeData.wifi)顆星"
        seatLabel.text = "\(cafeData.seat)顆星"
        quietLabel.text = "\(cafeData.quiet)顆星"
        tastyLabel.text = "\(cafeData.tasty)顆星"
        cheapLabel.text = "\(cafeData.cheap)顆星"
        musicLabel.text = "\(cafeData.music)顆星"
        officialWebsiteTextView.text = cafeData.url
        openTimeTextView.text = cafeData.open_time
        
        switch cafeData.limited_time {
        case "yes":
            limitedTimeLabel.text = "一律有限時"
        case "maybe":
            limitedTimeLabel.text = "看情況，假日或客滿限時"
        case "no":
            limitedTimeLabel.text = "一律不限時"
        default:
            limitedTimeLabel.text = ""
        }
        
        switch cafeData.socket {
        case "yes":
            socketLabel.text = "很多"
        case "maybe":
            socketLabel.text = "還好，看座位"
        case "no":
            socketLabel.text = "很少"
        default:
            socketLabel.text = ""
        }
        
        switch cafeData.standing_desk {
        case "yes":
            standingDeskLabel.text = "有些座位可以"
        case "no":
            standingDeskLabel.text = "無法"
        default:
            standingDeskLabel.text = ""
        }
    }

}
