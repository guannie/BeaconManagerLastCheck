//
//  beaconCustomCell.swift
//  beaconManager
//
//  Created by Tan Chung Shzen on 17.10.17.
//  Copyright © 2017 HDMI. All rights reserved.
//

import UIKit

class beaconCustomCell: UITableViewCell {

    @IBOutlet weak var beaconName: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var visibility: UILabel!
    @IBOutlet weak var battery_level: UILabel!
    @IBOutlet weak var battery_updated: UILabel!
    @IBOutlet weak var hardware: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customInit(_ beaconName: String, lat: Double, long: Double, vis: String, bl: String, bu: String, hardw: String){
        
            self.beaconName.text = beaconName
            self.latitude.text = "Latitude: " + String(lat)
            self.longitude.text = "Longitude: " + String(long)
            self.visibility.text = "Visibility: " + vis
            self.battery_level.text = "Battery Level: " + bl
            self.battery_updated.text = "Battery Updated On: " + bu
            self.hardware.text = "Hardware: " + hardw
        
    }

}
