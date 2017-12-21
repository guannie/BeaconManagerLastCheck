//
//  TouchCanvasViewController.swift
//  beaconManager
//
//  Created by Lee Kuan Xin on 20.10.17.
//  Copyright © 2017 HDMI. All rights reserved.
//

import UIKit
import HDMMapCore

class TouchCanvasViewController: BaseMapViewController, HDMDrawingProtocol {
    
    var mapView: HDMMapView!
        
//        = {
//        let app = UIApplication.shared.delegate as? AppDelegate
//        self.mapViewController = app?.mapViewController
//        return self.mapViewController.mapView
//    }()
    var polygonPoints = [AnyHashable]()
    @IBOutlet weak var drawPolygonButton: UIButton!
    @IBOutlet weak var drawRectangleButton: UIButton!
    //var freeformDrawHandler: HDMFreeformDrawHandler?
    var rectangleDrawHandler: HDMRectangleDrawHandler!
    weak var touchDrawHandler: HDMDrawHandlerProtocol?
    
    func getCoordinateFor(_ touch: UITouch) -> HDMMapCoordinate {
        return HDMMapCoordinate.init(x: 0, y: 0, z: 0)
    }
    
    func drawingFinished() {
        
    }
    
    //  Converted with Swiftify v1.0.6488 - https://objectivec2swift.com/
    @IBAction func didTouchUp(insideDraw sender: UIButton) {
//        drawPolygonButton.setTitle("done", for: .normal)
//        if freeformDrawHandler.isDrawing == false {
//            freeformDrawHandler.beginFreeformDrawing()
//            view.addSubview(freeformDrawHandler)
//            touchDrawHandler = freeformDrawHandler
//        }
//        else {
//            freeformDrawHandler.removeFromSuperview()
//            touchDrawHandler = nil
//        }
    }
    
    @IBAction func didTouchUp(insideDrawRectangleButton sender: UIButton) {
        drawRectangleButton.setTitle("done", for: .normal)
        if rectangleDrawHandler.isDrawing == false {
            rectangleDrawHandler.beginDrawing()
            view.addSubview(rectangleDrawHandler!)
            touchDrawHandler = rectangleDrawHandler as! HDMDrawHandlerProtocol
        }
        else {
            rectangleDrawHandler?.removeFromSuperview()
            touchDrawHandler = nil
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let app = UIApplication.shared.delegate as? AppDelegate
        self.mapViewController = app?.mapViewController
        self.mapView = self.mapViewController.mapView
        rectangleDrawHandler = HDMRectangleDrawHandler(frame: mapView.frame)
        rectangleDrawHandler.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
