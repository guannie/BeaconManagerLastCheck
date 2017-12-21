//
//  HDMRectangleDrawHandler.swift
//  beaconManager
//
//  Created by Lee Kuan Xin on 20.10.17.
//  Copyright © 2017 HDMI. All rights reserved.
//

import UIKit
import HDMMapCore

typealias LocationBound = (minLatitude: Double,
    maxLatitude: Double,
    minLongitude: Double,
    maxLongitude: Double)

class HDMRectangleDrawHandler: UIView, CanvasDrawingProtocol {
    
    var isDrawing = false
    weak var delegate: HDMDrawingProtocol?
    
    private var dragArea: UIView?
    private var dragAreaBounds = CGRect.zero
    var canvasView: SketchView!
    var coordinates = [AnyHashable]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        canvasView = SketchView(frame: frame)
        canvasView.isUserInteractionEnabled = true
        //canvasView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    func beginDrawing() {
        if isDrawing == false {
            isDrawing = true
            coordinates.removeAll()
            addSubview(canvasView)
        }
    }
    
    func drawBegan(at touch: UITouch) {
        // get real world coordinates for later drawing on the map
        let coordinate: HDMMapCoordinate = delegate!.getCoordinateFor(touch)
        coordinates.append(coordinate as! AnyHashable)
        //handle(touch)
        dragAreaBounds.origin = touch.location(in: self)
    }
    
    func drawMoved(to touch: UITouch) {
        //    CLLocationCoordinate2D coordinate = [self.delegate getCoordinateForTouch:touch];
        //    [self.coordinates addObject:[NSValue valueWithMKCoordinate:coordinate]];
        // get real world coordinates for later drawing on the map
        let coordinate: HDMMapCoordinate = delegate!.getCoordinateFor(touch)
        coordinates.append(coordinate as! AnyHashable)
        //handle(touch)
    }

    func drawEnded(at touch: UITouch) {
        // get real world coordinates for later drawing on the map
        let coordinate: HDMMapCoordinate = delegate!.getCoordinateFor(touch)
        coordinates.append(coordinate as! AnyHashable)
        isDrawing = false
        canvasView.image = nil
        canvasView.removeFromSuperview()
        handle(touch)
        setupView()
        dragArea?.removeFromSuperview()
        delegate?.drawingFinished()
    }


    
    func getFeature() -> HDMPolygonFeature {
        return HDMPolygonFeature()
    }

    
    func setupView() {
        dragAreaBounds = CGRect.zero
        self.isUserInteractionEnabled = true
        self.isMultipleTouchEnabled = false
        self.backgroundColor = UIColor.clear
        self.isOpaque = false
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func handle(_ touch: UITouch) {
        if coordinates.count < 2 {
            return
        }
        let location: CGPoint = touch.location(in: self)
        dragAreaBounds.size.height = location.y - dragAreaBounds.origin.y
        dragAreaBounds.size.width = location.x - dragAreaBounds.origin.x
        if dragArea == nil {
            let area = UIView(frame: dragAreaBounds)
            area.backgroundColor = UIColor.blue
            area.isOpaque = false
            area.alpha = 0.3
            area.isUserInteractionEnabled = false
            dragArea = area
            addSubview(dragArea!)
        }
        else {
            dragArea?.frame = dragAreaBounds
        }
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
}
