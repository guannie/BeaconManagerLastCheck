//
//  getBeacon.swift
//  beaconManager
//
//  Created by Tan Chung Shzen on 17.10.17.
//  Copyright © 2017 HDMI. All rights reserved.
//

import Foundation

struct Beacon : Codable{
    let id : String?
    let factory_id : String?
    let name : String?
    var latitude : Double?
    var longitude : Double?
    let visibility : String?
    let battery_level : String?
    let battery_updated_date : String?
    let hardware : String?
    
    init(id : String? = nil, factory_id : String? = nil, name : String? = nil, latitude : Double? = nil, longitude : Double? = nil, visibility : String? = nil, battery_level : String? = nil, battery_updated_date : String? = nil, hardware : String? = nil){
        self.id = id
        self.factory_id = factory_id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.visibility = visibility
        self.battery_level = battery_level
        self.battery_updated_date = battery_updated_date
        self.hardware = hardware
    }
}
