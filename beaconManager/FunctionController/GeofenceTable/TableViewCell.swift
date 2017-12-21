//
//  TableViewCell.swift
//  beaconManager
//
//  Created by Tan Chung Shzen on 16.10.17.
//  Copyright © 2017 HDMI. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var beaconNameLabel: UILabel!
    @IBOutlet weak var beaconFactoryIdLabel: UILabel!
    @IBOutlet weak var beaconIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
