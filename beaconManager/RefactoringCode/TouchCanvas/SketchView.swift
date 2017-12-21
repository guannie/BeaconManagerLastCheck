//
//  SketchView.swift
//  beaconManager
//
//  Created by Lee Kuan Xin on 20.10.17.
//  Copyright © 2017 HDMI. All rights reserved.
//

import UIKit

protocol CanvasDrawingProtocol: NSObjectProtocol {
    func drawBegan(at touch: UITouch)
    
    func drawMoved(to touch: UITouch)
    
    func drawEnded(at touch: UITouch)
}



class SketchView: UIImageView {
    
    var location = CGPoint.zero
    //var delegate: CanvasDrawingProtocol
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        let touch = touches.first!
        //delegate.drawBegan(at: touch)
        location = touch.location(in: self)
    }
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        let touch = touches.first!
        let currentLocation: CGPoint? = touch.location(in: self)
        //delegate.drawMoved(to: touch)
        UIGraphicsBeginImageContext(frame.size)
        let ctx: CGContext? = UIGraphicsGetCurrentContext()
        self.draw(CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        ctx?.setLineCap(.round)
        ctx?.setLineWidth(3.0)
        ctx?.setStrokeColor(UIColor.blue.withAlphaComponent(0.7).cgColor)
        ctx?.beginPath()
        ctx?.move(to: CGPoint(x: location.x, y: location.y))
        ctx?.addLine(to: CGPoint(x: (currentLocation?.x)!, y: (currentLocation?.y)!))
        ctx?.strokePath()
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        location = currentLocation!
    }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        let touch = touches.first!
        let currentLocation: CGPoint? = touch.location(in: self)
        //delegate.drawEnded(at: touch)
        UIGraphicsBeginImageContext(frame.size)
        let ctx: CGContext? = UIGraphicsGetCurrentContext()
        self.draw(CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        ctx?.setLineCap(.round)
        ctx?.setLineWidth(3.0)
        ctx?.setStrokeColor(UIColor.blue.withAlphaComponent(0.7).cgColor)
        ctx?.beginPath()
        ctx?.move(to: CGPoint(x: location.x, y: location.y))
        ctx?.addLine(to: CGPoint(x: (currentLocation?.x)!, y: (currentLocation?.y)!))
        ctx?.strokePath()
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        location = currentLocation!
    }
    
    func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        //delegate.drawEnded(at: touches.first!)
        // todo: cancelled
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
