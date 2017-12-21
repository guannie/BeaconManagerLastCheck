//
//  HDMCoordinate+PointHelper.swift
//  beaconManager
//
//  Created by Lee Kuan Xin on 20.10.17.
//  Copyright © 2017 HDMI. All rights reserved.
//

import Foundation
import HDMMapCore


extension HDMMapCoordinate {
    
    // MARK: Format caster
    public func castToLatLong() -> (CLLocationCoordinate2D, Double) {
        let coordXY = CLLocationCoordinate2DMake(self.x, self.y)
        let coordZ = self.z
        return (coordXY, coordZ)
    }
    
    public func getScreenPoint(from mapView: HDMMapView) -> CGPoint{
        return mapView.getPointOnScreen(fromMapPoint: self)
    }
    
}

