//
//  setGeofence.swift
//  beaconManager
//
//  Created by Tan Chung Shzen on 25.10.17.
//  Copyright © 2017 HDMI. All rights reserved.
//

import Foundation

struct setGeofence : Codable{
    
    struct Geofence : Codable{
        
        var shape: String?
        
        struct Points : Codable{
            var latitude: Double?
            var longitude: Double?
        }
        
        var points: [Points]?
    }
    
    var geofence: Geofence?
  
    
    init(geofence: Geofence? = nil){
        self.geofence = geofence
    }
}

