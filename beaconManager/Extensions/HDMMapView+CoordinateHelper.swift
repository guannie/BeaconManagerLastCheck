//
//  HDMCoordinate+CoordinateHelper.swift
//  beaconManager
//
//  Created by Lee Kuan Xin on 20.10.17.
//  Copyright © 2017 HDMI. All rights reserved.
//

import Foundation
import HDMMapCore

extension HDMMapView {
    // MARK:
    // single Point conversion
    public func getCoordinateOnMapForTouch(_ touch: UITouch) -> (HDMMapCoordinate) {
        var location: CGPoint = touch.location(in: self)
        location.x *= self.contentScaleFactor
        location.y *= self.contentScaleFactor
        let mapLocation: HDMLocation = self.getLocationOnMap(from: Float(location.x), screenPointY: Float(location.y))
        return mapLocation.coordinate
    }
    
    public func getCoordinateForTouches(_ touches: [UITouch])->([HDMMapCoordinate]) {
        var coordinates = [HDMMapCoordinate]()
        for touch in touches{
            coordinates.append(self.getCoordinateOnMapForTouch(touch))
        }
        return coordinates
    }
}
