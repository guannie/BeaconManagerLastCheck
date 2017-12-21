//
//  ViewController.swift
//  beaconManager
//
//  Created by Lee Kuan Xin on 19.10.17.
//  Copyright © 2017 HDMI. All rights reserved.
//

import UIKit

class MapViewController: BaseMapViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let app = UIApplication.shared.delegate as? AppDelegate
        self.mapViewController = app?.mapViewController
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //setupDrawStack()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Setup View to Display
    func setupView() {
        setupDrawStack()
    }
    
    
    
    // MARK: Test
    
//    func setupAfterMapLoad() {
//        addGestureListener()
//    }
    
    func setupDrawStack() {
        
        let drawStack = DrawStackView()
        view.addSubview(drawStack)
        drawStack.anchor(view.topAnchor,
                         left: nil,
                         bottom: view.bottomAnchor,
                         right: view.rightAnchor,
                         topConstant: 0,
                         leftConstant: 0,
                         bottomConstant: 0,
                         rightConstant: 0,
                         widthConstant: 70,
                         heightConstant: 320)
        drawStack.tapButton.addTarget(self, action: #selector(MapViewController.functionSelector(_:)), for: .touchUpInside)
        drawStack.rectButton.addTarget(self, action: #selector(MapViewController.functionSelector(_:)), for: .touchUpInside)
        drawStack.lineButton.addTarget(self, action: #selector(MapViewController.functionSelector(_:)), for: .touchUpInside)
        drawStack.polyButton.addTarget(self, action: #selector(MapViewController.functionSelector(_:)), for: .touchUpInside)
    }
    
    func setupCanvasView() {
        
    }
    
    
    @objc func functionSelector(_ button: UIButton) {
        
        //if(self.isDrawing == false) {
            //prepareForDrawing(button)
        //} else if(checkPoints()){
            //prepareToEndDrawing(button)
        //}
    }
    
//    func prepareForDrawing(_ sender: UIButton) {
//        sender.self.setTitle("Done", for: UIControlState.normal)
//        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
//        if ( type == .tap) {
//        }else{
//            drawPolygon = DrawPolygon(frame: frame)
//            drawPolygon.setCurrentMap(mapView: mapView)
//            drawPolygon.setGesture(type)
//            self.view.addSubview(drawPolygon)
//            drawPolygon.canvasView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
//        }
//        self.view.bringSubview(toFront: drawStack)
//        self.isDrawing = true
//    }
//
//    func prepareToEndDrawing(_ sender: UIButton, _ type: Gesture, _ oriImage: UIImage) {
//        drawPolygon.removeFromSuperview()
//        drawFinished()
//        drawPolygon = nil
//        self.isDrawing = false
//    }
    
//    func prepareToEndDrawingTap(_ sender: UIButton, _ type: Gesture, _ oriImage: UIImage) {
//        sender.self.setImage(oriImage, for: UIControlState.normal)
//        sender.self.setTitle("Draw", for: UIControlState.normal)
//        self.isDrawing = false
//        self.drawStack.isHidden = false
//    }
    
    // Finish drawing saving values before navigation
//    func drawFinished(){
//        let polyPoint = drawPolygon.pointSelector()
//        prepareForNavigation(polyPoint)
//    }
//
//    // MARK: Can be optimize
//    func checkPoints() -> Bool{
//        let coordinates: [HDMMapCoordinate] = drawPolygon.coordinates as! [HDMMapCoordinate]
//        if coordinates.count == 0 || coordinates.count == 1{
//            var message : String?
//            if coordinates.count == 0 {message = "Oh no! you need to draw something!"}
//            else if coordinates.count == 1 {message = "There is only one point on the map"}
//            let alertController = UIAlertController(title: "Not Enough Points Selected", message: message, preferredStyle: .alert)
//
//            let confirmButton = UIAlertAction(title: "OK", style: .default) { (_) in
//                self.drawPolygon.clear()
//            }
//
//            alertController.addAction(confirmButton)
//
//            if !(self.navigationController?.visibleViewController?.isKind(of: UIAlertController.self))! {
//                self.present(alertController, animated: true, completion: nil)
//            }
//            return false
//        }
//        return true
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
