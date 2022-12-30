//
//  MapCafeDetailTableViewController.swift
//  CafeApp
//
//  Created by Machir on 2022/12/19.
//

import UIKit

class MapCafeDetailTableViewController: UITableViewController {
    
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
        
        if cafeData.open_time == "" {
            openTimeTextView.text = "-"
        } else {
            openTimeTextView.text = cafeData.open_time
            
        }
        
        nameLabel.text = cafeData.name
        
        if cafeData.address == "" {
            addressTextView.text = "-"
        } else {
            addressTextView.text = cafeData.address
        }
        
        if cafeData.mrt == "" {
            mrtLabel.text = "-"
        } else {
            mrtLabel.text = cafeData.mrt
        }
        
        if cafeData.url == "" {
            officialWebsiteTextView.text = "-"
        } else {
            officialWebsiteTextView.text = cafeData.url
        }
        
        
        switch cafeData.wifi {
        case 0:
            wifiLabel.text = "☆☆☆☆☆"
        case 0.5, 1:
            wifiLabel.text = "★☆☆☆☆"
        case 1.5, 2:
            wifiLabel.text = "★★☆☆☆"
        case 2.5, 3:
            wifiLabel.text = "★★★☆☆"
        case 3.5, 4:
            wifiLabel.text = "★★★★☆"
        case 4.5, 5:
            wifiLabel.text = "★★★★★"
        default:
            wifiLabel.text = "☆☆☆☆☆"
        }
        
        switch cafeData.seat {
        case 0:
            seatLabel.text = "☆☆☆☆☆"
        case 0.5, 1:
            seatLabel.text = "★☆☆☆☆"
        case 1.5, 2:
            seatLabel.text = "★★☆☆☆"
        case 2.5, 3:
            seatLabel.text = "★★★☆☆"
        case 3.5, 4:
            seatLabel.text = "★★★★☆"
        case 4.5, 5:
            seatLabel.text = "★★★★★"
        default:
            seatLabel.text = "☆☆☆☆☆"
        }
        
        switch cafeData.quiet {
        case 0:
            quietLabel.text = "☆☆☆☆☆"
        case 0.5, 1:
            quietLabel.text = "★☆☆☆☆"
        case 1.5, 2:
            quietLabel.text = "★★☆☆☆"
        case 2.5, 3:
            quietLabel.text = "★★★☆☆"
        case 3.5, 4:
            quietLabel.text = "★★★★☆"
        case 4.5, 5:
            quietLabel.text = "★★★★★"
        default:
            quietLabel.text = "☆☆☆☆☆"
        }
        
        switch cafeData.tasty {
        case 0:
            tastyLabel.text = "☆☆☆☆☆"
        case 0.5, 1:
            tastyLabel.text = "★☆☆☆☆"
        case 1.5, 2:
            tastyLabel.text = "★★☆☆☆"
        case 2.5, 3:
            tastyLabel.text = "★★★☆☆"
        case 3.5, 4:
            tastyLabel.text = "★★★★☆"
        case 4.5, 5:
            tastyLabel.text = "★★★★★"
        default:
            tastyLabel.text = "☆☆☆☆☆"
        }
        
        switch cafeData.cheap {
        case 0:
            cheapLabel.text = "☆☆☆☆☆"
        case 0.5, 1:
            cheapLabel.text = "★☆☆☆☆"
        case 1.5, 2:
            cheapLabel.text = "★★☆☆☆"
        case 2.5, 3:
            cheapLabel.text = "★★★☆☆"
        case 3.5, 4:
            cheapLabel.text = "★★★★☆"
        case 4.5, 5:
            cheapLabel.text = "★★★★★"
        default:
            cheapLabel.text = "☆☆☆☆☆"
        }
        
        switch cafeData.music {
        case 0:
            musicLabel.text = "☆☆☆☆☆"
        case 0.5, 1:
            musicLabel.text = "★☆☆☆☆"
        case 1.5, 2:
            musicLabel.text = "★★☆☆☆"
        case 2.5, 3:
            musicLabel.text = "★★★☆☆"
        case 3.5, 4:
            musicLabel.text = "★★★★☆"
        case 4.5, 5:
            musicLabel.text = "★★★★★"
        default:
            musicLabel.text = "☆☆☆☆☆"
        }
        
        switch cafeData.limited_time {
        case "yes":
            limitedTimeLabel.text = "一律有限時"
        case "maybe":
            limitedTimeLabel.text = "看情況，假日或客滿限時"
        case "no":
            limitedTimeLabel.text = "一律不限時"
        default:
            limitedTimeLabel.text = "-"
        }
        
        switch cafeData.socket {
        case "yes":
            socketLabel.text = "很多"
        case "maybe":
            socketLabel.text = "還好，看座位"
        case "no":
            socketLabel.text = "很少"
        default:
            socketLabel.text = "-"
        }
        
        switch cafeData.standing_desk {
        case "yes":
            standingDeskLabel.text = "有些座位可以"
        case "no":
            standingDeskLabel.text = "無法"
        default:
            standingDeskLabel.text = "-"
        }
    }
}
