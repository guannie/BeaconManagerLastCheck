//
//  File.swift
//  beaconManager
//
//  Created by Lee Kuan Xin on 20.10.17.
//  Copyright © 2017 HDMI. All rights reserved.
//

import Foundation
import HDMMapCore


protocol HDMDrawingProtocol: NSObjectProtocol {
    func getCoordinateFor(_ touch: UITouch) -> HDMMapCoordinate
    func drawingFinished()
}

// to be implemented by the view that draws something on touch events in realtime
protocol HDMDrawHandlerProtocol: NSObjectProtocol {
    func beginFreeformDrawing()
    
    func getFeature() -> HDMPolygonFeature
}
