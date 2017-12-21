//
//  MainViewController.swift
//  MultipleHDMMapView
//
//  Created by Tan Chung Shzen on 27.09.17.
//  Copyright © 2017 HDMI. All rights reserved.
//

import UIKit
import HDMMapCore

class MainViewController: HDMMapViewController, HDMMapViewControllerDelegate {

    //variable to keep track of the geofence
    var feature : [HDMFeature] = []
    var emptyFeature = HDMFeature()
    var featureId : [UInt64] = []
    let emptyID = UInt64()
    var annotation : [HDMAnnotation?] = []
    var nameArray = [String] ()
    var urlArray = [String] ()
    var beaconName : [String] = []
    var name : String?
    var arrayPointX = [[Double]] () //Used to set a boundary so that beacon can only be set in their own respective region
    var arrayPointY = [[Double]] ()
    var pointX = [Double] ()
    var pointY = [Double] ()
    
    //variable for drawings and coordinates
    var coordinateX = [Double] ()
    var coordinateY = [Double] ()
    var beaconX : Double?
    var beaconY : Double?
    var tapLocation = [CGPoint] ()
    var canvasView: CanvasView!
    var drawPolygon: DrawPolygon!
    
    //standalone variables for specific usage
    var status : String? //to obtain status of the app's flow
    var url : String? //to obtain specific url from other classes
    var urlIndex : Int? //to act as a specific index for the array
    var modeSelected: Bool = false
    var isDrawing: Bool = false
    var t: UIGestureRecognizer!
    var gestureType: Gesture = .tap

    // Draw Menu
    @IBOutlet weak var drawStackContainer: UIView!
    @IBOutlet weak var drawStack: UIStackView!
    @IBOutlet weak var tapBtn: UIButton!
    @IBOutlet weak var rectBtn: UIButton!
    @IBOutlet weak var lineBtn: UIButton!
    @IBOutlet weak var polyBtn: UIButton!
    
    @IBOutlet weak var menuBtn: UIButton!
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        if let origin = segue.source as? UpdateViewController {
            status = origin.status
            url = origin.urlMain
        }
        if let origin = segue.source as? CreateViewController {
            status = origin.status
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("Mainview Did Load")
        self.delegate = self
        self.mapView.tapEnabled = true
        self.view.addSubview(self.menuBtn)
        self.menuBtn.isHidden = true
        self.drawStackContainer.isHidden = false
        self.drawStackContainer.layer.borderColor = UIColor.white.cgColor
        self.drawStackContainer.layer.backgroundColor = UIColor(hexString: "#96accf77")?.cgColor
        self.drawStackContainer.layer.borderWidth = 1
        self.drawStackContainer.layer.cornerRadius = 10
        self.drawStack.isHidden = false
        for btn in drawStack.subviews {
            btn.layer.borderWidth = 1
            btn.layer.backgroundColor = UIColor.white.cgColor
            btn.layer.borderColor = UIColor(hexString: "#96accf77")?.cgColor
            btn.layer.cornerRadius = 20
            
        }
        
        //observer of confirmCreate
        NotificationCenter.default.addObserver(self, selector: #selector(self.confirmCreate(_:)), name: NSNotification.Name(rawValue: "confirmCreate"), object: nil)
        //observer of confirmUpdate
        NotificationCenter.default.addObserver(self, selector: #selector(self.confirmUpdate(_:)), name: NSNotification.Name(rawValue: "confirmUpdate"), object: nil)
        //observer of updateGeofence
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateGeofence(_:)), name: NSNotification.Name(rawValue: "updateGeofence"), object: nil)
        //observer of deletegeofence
        NotificationCenter.default.addObserver(self, selector: #selector(self.deleteGeofence(_:)), name: NSNotification.Name(rawValue: "deleteGeofence"), object: nil)
        //observer of alertController
        NotificationCenter.default.addObserver(self, selector: #selector(self.deleteGeofence(_:)), name: NSNotification.Name(rawValue: "alertError"), object: nil)
        //observer of moveToRegion
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveToRegion(_:)), name: NSNotification.Name(rawValue: "moveToRegion"), object: nil)
        //observer of getBeaconCoordinate
        NotificationCenter.default.addObserver(self, selector: #selector(self.getBeaconCoordinate(_:)), name: NSNotification.Name(rawValue: "getBeaconCoordinate"), object: nil)
       
        //Import data from Gimbal Server
        let testdata = DataHandler()
      
        testdata.getSpecificPlace(){
            place in
            
            if (place?.feature == nil) {
                self.feature.append(self.emptyFeature)
                self.annotation.append(nil)
                self.nameArray.append((place?.place?.name)!)
                self.urlArray.append((place?.place?.url)!)
                self.featureId.append(self.emptyID)
                let zero = [0.0]
                self.arrayPointX.append(zero)
                self.arrayPointY.append(zero)
                if !((place?.place?.beacons?.isEmpty)!){
                    for beacon in (place?.place?.beacons)! {
                        self.beaconName.append(beacon.name!)
                    }
                } else {
                    self.beaconName.append("")
                }
                
            } else {
                self.feature.append((place?.feature)!)
                self.annotation.append((place?.annotation)!)
                self.nameArray.append((place?.place?.name)!)
                self.urlArray.append((place?.place?.url)!)
                
                //remove all previous points
                self.pointX.removeAll()
                self.pointY.removeAll()
                
                for p in 0..<(place?.place?.geofence?.points?.count)!-1{
                    self.pointX.append((place?.place?.geofence?.points![p].longitude)!)
                    self.pointY.append((place?.place?.geofence?.points![p].latitude)!)
                }
                
                self.arrayPointX.append(self.pointX)
                self.arrayPointY.append(self.pointY)
                
                if !((place?.place?.beacons?.isEmpty)!){
                    for beacon in (place?.place?.beacons)! {
                        self.beaconName.append(beacon.name!)
                    }
                } else {
                    self.beaconName.append("")
                }
             
                DispatchQueue.main.async {
                    //self.mapView.add(place?.annotation)
                }
                self.mapView.add((place?.feature)!)
                self.featureId.append((place?.feature?.featureId)!)
            }
           
            self.getData(self.urlArray,self.feature)
            self.printVar()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        if status == "create" {createGeofence()}

        mapView.reloadInputViews()
        
        print("Mainview will Appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Mainview did Appear")
        view.bringSubview(toFront: drawStack)
        view.bringSubview(toFront: drawStackContainer)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Mainview did Disappear")
        self.status = ""
        self.mapView.tapEnabled = true
        self.coordinateX.removeAll()
        self.coordinateY.removeAll()
        if self.canvasView != nil{
            self.canvasView.removeFromSuperview()
            self.canvasView.image = nil
            self.canvasView = nil
            self.tapLocation.removeAll()
            self.view.removeGestureRecognizer(t)
        }

    }
    
    func mapViewControllerDidStart(_ controller: HDMMapViewController, error: Error?) {
        setupAfterMapLoad()
    }
    
    func mapViewControllerDidPan(_ controller: HDMMapViewController) {
        if canvasView != nil { canvasView.clear() }
    }
    
    func mapViewControllerDidZoom(_ controller: HDMMapViewController) {
         if canvasView != nil { canvasView.clear() }
    }
    
    func mapViewController(_ controller: HDMMapViewController, tappedAt coordinate: HDMMapCoordinate, features: [HDMFeature]) {
        
        if canvasView != nil { canvasView.clear() }
        
        if status == "beacon"{
            if let i = urlArray.index(of: url!){
               let status = pointInPolygon(nvert: arrayPointX[i].count-1, vertx: arrayPointX[i], verty: arrayPointY[i], testx: coordinate.y, testy: coordinate.x)
                if (status){
                    beaconX = coordinate.x
                    beaconY = coordinate.y

                    if canvasView != nil { canvasView.clear() }
                    let origin = coordinate.getScreenPoint(from: mapView)
                    canvasView = CanvasView(frame: CGRect(origin: origin, size: CGSize(width: 10, height: 10)))
                    canvasView.bgcColor = UIColor.clear
                    let pointer = canvasView.createPointer(on: CGPoint(x: 5, y: 5))
                    canvasView.addSubview(pointer)
                    print(canvasView.bgcColor)
                    mapView.addSubview(canvasView)
                    let data = DataHandler()
                    let update = Beacon(id: data.getBeaconId(beaconName: name!), factory_id: data.getBeaconFactoryId(beaconName: name!), latitude: beaconX, longitude: beaconY)
                    data.updateBeaconCoordinate(update)

                    let beacon = ["name" : name ?? "Null", "beaconX" : beaconX ?? 0.0, "beaconY" : beaconY ?? 0.0] as [String : Any]

                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTableCell"), object: nil, userInfo: beacon)
                    
                    showPositiveMessage(message: "Beacon Coordinate Updated")
                    
                    self.mapView.tapEnabled = true

                    self.status = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        if self.canvasView != nil { self.canvasView.clear() }}
                }else{
                    showNegativeMessage(message: "Out of Region Boundaries")
                }
            }
        }
        else
        {
        guard let feature = features.first else {return}
        if isDrawing == true {
            if feature.featureType == "stand_rooms"{
            var polyPoint : [HDMPoint] = []
            let xo = feature.bounds.center.x
            let yo = feature.bounds.center.y
            let z = feature.bounds.center.z
            let spanX = feature.bounds.span.latitudeDelta
            let spanY = feature.bounds.span.longitudeDelta
            var w = spanX/2
            var h = spanY/2
            let x = xo - w
            let y = yo - h
            let point1 = HDMPoint(x, y: y, z: z)
            let point2 = HDMPoint(x + spanX, y: y, z: z)
            let point3 = HDMPoint(x + spanX, y: y + spanY, z: z)
            let point4 = HDMPoint(x, y: y + spanY, z: z)
            polyPoint.append(contentsOf: [point1, point2, point3, point4, point1])
            
            for point in polyPoint {
                coordinateX.append(point.coordinate.x)
                coordinateY.append(point.coordinate.y)
            }
            
            prepareToCreate(polyPoint)

            }
        }
            
        // Todo Tally with the normal feature deletion
        if feature.featureType == "" {
            if let index = self.featureId.index(of: feature.featureId ){

                let alertController = UIAlertController(title: "Manage Geofence", message: "Do you wish to Delete \(self.nameArray[index]) ?", preferredStyle: .alert)
                
                let updateAction = UIAlertAction(title: "Update", style: .default) { (_) in
                    
                    let data = ["url" : self.urlArray[index]]
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateGeofence"), object: nil, userInfo: data)
                }
                
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in

                    let data = DataHandler()
                    if self.urlArray.count-1 == index {
                    data.deletePlace(self.urlArray[index])
                    }else{
                        self.showNegativeMessage(message: "The server is still updating your previous operation, please try again.")
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                
                alertController.addAction(updateAction)
                alertController.addAction(deleteAction)
                alertController.addAction(cancelAction)

                self.present(alertController, animated: true, completion: nil)
            }
        }
      }
        
    }
    
    func mapViewController(_ controller: HDMMapViewController, longPressedAt coordinate: HDMMapCoordinate, features: [HDMFeature]) {
        guard let f = features.first else {return}
        
        print("Selecting object with ID \(f.featureId)")
        
        if let index = self.featureId.index(of: f.featureId ){
            
            let alertController = UIAlertController(title: "Manage Geofence", message: "Do you wish to Update or Delete \(self.nameArray[index]) ?", preferredStyle: .alert)
            
            let updateAction = UIAlertAction(title: "Update", style: .default) { (_) in
                self.url = self.urlArray[index]
                
                let naviController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpdateViewController") as? UpdateViewController
                
                naviController?.name = self.nameArray[index]
                naviController?.url = self.url!
                naviController?.beaconId = self.beaconName[index]
                
                self.navigationController?.pushViewController(naviController!, animated: true)
            }
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                
                let data = DataHandler()
                data.deletePlace(self.urlArray[index])
                self.mapView.remove(f)
                
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            
            alertController.addAction(updateAction)
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func pointInPolygon(nvert: Int, vertx: [Double], verty: [Double], testx: Double, testy: Double)->(Bool)
    {
        var j = nvert
        
        var c = false
        var temp : Double
        if (nvert == 3){
            if ((testx>vertx[0] && testx<vertx[2]) && (testy>verty[0] && testy<verty[2])){
                c = true
            }
        } else {
            for i in 1..<(nvert+2){
                
                let A = !((verty[0]>testy) == (verty[j]>testy))
                temp = (vertx[j]-vertx[0]) * (testy-verty[0])
                
                temp = temp / (verty[j]-verty[0])

                temp = temp + vertx[0]
             
                let B = (testx < temp)
               
                if ( A && B ){
                    c = !c
                }
                j = i
            }
        }
        print(c)
        return c
    }
    
    func createGeofence(){
        showPositiveMessage(message: "Select drawing method to start")
            //refresh tapCoordinates
            self.coordinateX.removeAll()
            self.coordinateY.removeAll()
            if self.canvasView != nil{
                self.canvasView.removeFromSuperview()
                self.canvasView.image = nil
                self.canvasView = nil
                self.tapLocation.removeAll()
            }
            
            self.drawStackContainer.isHidden = false
            self.drawStack.isHidden = false
            self.tapBtn.isHidden = false
            self.rectBtn.isHidden = false
            self.lineBtn.isHidden = false
            self.polyBtn.isHidden = false
            self.menuBtn.isHidden = true
    }
    
    //receiver function - updateGeofence
    
    @objc func updateGeofence(_ notification: NSNotification){
        
        let url = notification.userInfo?["url"] as? String
        
        if let index = self.urlArray.index(of: url!){
          
                urlIndex = index
                //alert user
                showPositiveMessage(message: "Select one of the drawing method to continue")
                    
                    self.status = "geofence"
                    DispatchQueue.main.async {
                        self.mapView.remove(self.annotation[index])
                        self.mapView.remove(self.feature[index])
                    }
        }
    }
    
    //receiver function - confirmCreate
    @objc func confirmCreate(_ notification: NSNotification){
        if let name = notification.userInfo?["name"] as? String{
            
            let getData = DataHandler()
            getData.getSpecificPlace(){
                place in
                if (name.isEqual(place?.place?.name)){
                    self.feature.append((place?.feature)!)
                    self.annotation.append((place?.annotation)!)
                    self.nameArray.append((place?.place?.name)!)
                    self.urlArray.append((place?.place?.url)!)
                    
                    if !((place?.place?.beacons?.isEmpty)!){
                        for beacon in (place?.place?.beacons)! {
                            self.beaconName.append(beacon.name!)
                        }
                    } else {
                        self.beaconName.append("")
                    }
                    
                    //remove all previous points
                    self.pointX.removeAll()
                    self.pointY.removeAll()
                    
                    for p in 0..<(place?.place?.geofence?.points?.count)!-1{
                        self.pointX.append((place?.place?.geofence?.points![p].longitude)!)
                        self.pointY.append((place?.place?.geofence?.points![p].latitude)!)
                    }
                    
                    self.arrayPointX.append(self.pointX)
                    self.arrayPointY.append(self.pointY)
                    
                    self.mapView.add((place?.feature)!)
                    self.featureId.append((place?.feature?.featureId)!)
                    self.printVar()
                }
            }
        }
    }
    
    //receiver function - confirmUpdate
    @objc func confirmUpdate(_ notification: NSNotification){
        if let url = notification.userInfo?["url"] as? String{
            if let index = urlArray.index(of: url){
                
                let getData = DataHandler()
                getData.getSpecificPlace(){
                    place in
                    if (url == place?.place?.url){
                        
                        self.nameArray[index] = (place?.place?.name)!
                        self.feature[index] = (place?.feature)!
                        self.annotation[index] = (place?.annotation)!
                        if !((place?.place?.beacons?.isEmpty)!){
                            for beacon in (place?.place?.beacons)! {
                                self.beaconName[index] = beacon.name!
                            }
                        } else {
                            self.beaconName[index] = ""
                        }
                        
                        //remove all previous points
                        self.pointX.removeAll()
                        self.pointY.removeAll()
                        
                        for p in 0..<(place?.place?.geofence?.points?.count)!-1{
                            self.pointX.append((place?.place?.geofence?.points![p].longitude)!)
                            self.pointY.append((place?.place?.geofence?.points![p].latitude)!)
                        }
                        
                        self.arrayPointX[index] = self.pointX
                        self.arrayPointY[index] = self.pointY
                        
                        DispatchQueue.main.async {
                            self.mapView.add(place?.annotation)
                        }
                        
                        self.mapView.add((place?.feature)!)
                        self.featureId[index] = (place?.feature?.featureId)!
                        self.printVar()
                    }
                }
            }
        }
    }
    
    //receiver function - deletegeofence
    @objc func deleteGeofence(_ notification: NSNotification){
        if let url = notification.userInfo?["url"] as? String{
            if let index = urlArray.index(of: url ){
                if !(self.annotation[index] == nil){
                    self.mapView.remove(self.annotation[index])
                    self.mapView.remove(self.feature[index])
                }
                urlArray.remove(at: index)
                nameArray.remove(at: index)
                annotation.remove(at: index)
                feature.remove(at: index)
                featureId.remove(at: index)
                beaconName.remove(at: index)
                arrayPointX.remove(at: index)
                arrayPointY.remove(at: index)
            }
        }
    }
    
    //receiver function - deletegeofence
    @objc func alertError(_ notification: NSNotification){
        showNegativeMessage(message: "Error uploading to server, please try again.")
    }
    
    //receiver function - moveToRegion
    @objc func moveToRegion(_ notification: NSNotification){
        if let url = notification.userInfo?["url"] as? String{
            if let index = urlArray.index(of: url ){
            if !(annotation[index] == nil){
                    let cam: HDMMapCamera = HDMMapCamera(lookAt: (self.annotation[index]?.coordinate)!, distance: 20.1238632202148, bearingAngle: -3.18055471858951e-15, tiltAngle: 90.0)
                
                    mapView.setCamera(cam, animated: true)
                DispatchQueue.main.async {
                    self.mapView.setFeatureAttribute("moved", value: "100", withFeatureId: self.feature[index].featureId)
                }
                self.mapView.highlightFeature(withId: self.feature[index].featureId)
                
                print(self.feature[index].attributes)
                mapView.reloadStyle()
                
                }
            }
        }
    }
    
    //receiver function - getBeaconCoordinate
    @objc func getBeaconCoordinate(_ notification: NSNotification){
        self.showPositiveMessage(message: "Tap on the region to set coordinate for beacons")
            if let status = notification.userInfo?["status"] as? String{self.status = status}
            if let url = notification.userInfo?["url"] as? String{self.url = url}
            if let name = notification.userInfo?["name"] as? String{
                self.mapView.tapEnabled = true
                self.name = name
            }
    }
    
    //get url from completion handler to be use in MAIN
    func getData(_ url : [String], _ f: [HDMFeature]){
        self.urlArray = url
        self.feature = f
        
    }
    
    func addData(_ url : String){
        self.urlArray.append(url)
    }
    
    //Used for keeping track of array counts and checking behaviour of the datasets after each operation
    func printVar(){
        print("feature:\(self.feature.count)")
        print("url:\(self.urlArray.count)")
        print("annotation:\(self.annotation.count)")
        print("beacon:\(self.beaconName.count)")
        print("fid:\(self.featureId.count)")
        print("name:\(self.nameArray.count)")
    }
    
    // Setup
    func setupAfterMapLoad() {
        // mapView.stopAllCameraAnimations()
        //mapView.setFeatureStyle("poly", propertyName: "fill-color", value: "#e9bc00")
        //mapView.reloadStyle()
        mapView.set3DMode(false, animated: false)
        //mapView.setRegion(HDMMapCoordinateRegionMake(49.418397, 8.675501, 0, 0.000213, 0.000213), animated: false)
        // Map is too small thus zoom region not big enough
         mapView.moveToFeature(withId: 19392, animated: false)
        
        // For user interaction
        mapView.rotateEnabled = false
        mapView.tiltEnabled = false
        addGestureListener()
    }
    
    // Gesture Listener for tap effect
    func addGestureListener(){
        //For gesture respond
        if mapView.tapEnabled == true {
//            t = UITapGestureRecognizer(target: self, action: #selector(tapEffectHandler))
//            view.addGestureRecognizer(t)
        }
    }
    
    

    //    MARK:TAP effect
    @objc func tapEffectHandler(gesture: UITapGestureRecognizer) {
        
        // handle touch up/tap event
        if gesture.state == .ended {
            // temp make sure the tap is lower than the menu bar
            if gesture.location(in: mapView).y > 65.0 {
            let tap = gesture.location(in: mapView)
                // check number of points to make sure the rendered list is the same before appending
                if tapLocation.count > coordinateX.count{
                    //tapLocation.removeAll()
                }
            tapLocation.append(tap)
            print(tapLocation)
            
            // making sure canvasView is empty
            if canvasView != nil{
                canvasView.removeFromSuperview()
                canvasView = nil
            }
            // initialize the canvasView
            canvasView = CanvasView(frame: self.mapView.frame)
            self.view.addSubview(canvasView)
            // drawing gesture feedback
            var prev = tapLocation.first
            for i in tapLocation {
                canvasView.addSubview(canvasView.createPointer(on: i))
                canvasView.drawLineFrom(fromPoint: prev!, toPoint: i)
                prev = i
            }
            canvasView.drawLineFrom(fromPoint: prev!, toPoint: tapLocation.first!)  //Enclose the polygon
            } else {
                mapView.tapEnabled = false
                dismiss(animated: true, completion: nil)
            }
        }
    }

    @IBAction func tapAction(_ sender: UIButton) {
        let oriImage = #imageLiteral(resourceName: "tap")
        lineBtn.isHidden = true
        rectBtn.isHidden = true
        polyBtn.isHidden = true
//        if !(t == nil){view.removeGestureRecognizer(t)}
//        DispatchQueue.main.async {
            self.mapView.tapEnabled = true
//            self.addGestureListener()
//            self.gestureType = .tap
//        }
        gestureType = .tap
        if(self.isDrawing == false) {
            self.isDrawing = true
            sender.self.setImage(#imageLiteral(resourceName: "done"), for: UIControlState.normal)
            lineBtn.isHidden = true
            rectBtn.isHidden = true
            polyBtn.isHidden = true
        } else{
            self.isDrawing = false
            var points : [putPlace.Geofence.Points] = []
            sender.self.setImage(oriImage, for: .normal)
            lineBtn.isHidden = false
            rectBtn.isHidden = false
            polyBtn.isHidden = false
            
        }
    }
    
    @IBAction func rectAction(_ sender: UIButton) {
        let oriImage = #imageLiteral(resourceName: "rect")
        print(drawStackContainer.frame)
        lineBtn.isHidden = true
        tapBtn.isHidden = true
        polyBtn.isHidden = true
        mapView.tapEnabled = false
        if !(t == nil){view.removeGestureRecognizer(t)}
        gestureType = .rect
        if(self.isDrawing == false) {
            prepareForDrawing(sender, gestureType)
        } else if(checkPoints()){
            prepareToEndDrawing(sender, gestureType, oriImage)
        }
    }
    
    @IBAction func lineAction(_ sender: UIButton) {
        let oriImage = #imageLiteral(resourceName: "line")
        tapBtn.isHidden = true
        rectBtn.isHidden = true
        polyBtn.isHidden = true
        mapView.tapEnabled = false
        if !(t == nil){view.removeGestureRecognizer(t)}
        gestureType = .line
        if(self.isDrawing == false) {
            prepareForDrawing(sender, gestureType)
        } else if(checkPoints()) {
            prepareToEndDrawing(sender, gestureType, oriImage)
        }
    }
    @IBAction func polyAction(_ sender: UIButton) {
        let oriImage = #imageLiteral(resourceName: "poly")
        lineBtn.isHidden = true
        rectBtn.isHidden = true
        tapBtn.isHidden = true
        mapView.tapEnabled = false
        if !(t == nil){view.removeGestureRecognizer(t)}
        gestureType = .poly
        if(self.isDrawing == false) {
            prepareForDrawing(sender, gestureType)
        } else if(checkPoints()) {
            prepareToEndDrawing(sender, gestureType, oriImage)
        }
    }
    
    func prepareForDrawing(_ sender: UIButton, _ type: Gesture) {
        sender.self.setImage(#imageLiteral(resourceName: "done"), for: UIControlState.normal)
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        if ( type == .tap) {
        }else{
            drawPolygon = DrawPolygon(frame: frame)
            drawPolygon.setCurrentMap(mapView: mapView)
            drawPolygon.setGesture(type)
            self.view.addSubview(drawPolygon)
            drawPolygon.canvasView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
        self.view.bringSubview(toFront: drawStackContainer)
        self.view.bringSubview(toFront: drawStack)
        self.isDrawing = true
    }
    
    func prepareToEndDrawing(_ sender: UIButton, _ type: Gesture, _ oriImage: UIImage) {
        sender.self.setImage(oriImage, for: UIControlState.normal)
        sender.self.setTitle("Draw", for: UIControlState.normal)
        
        drawPolygon.removeFromSuperview()
        drawFinished()
        drawPolygon = nil
        self.isDrawing = false
        mapView.tapEnabled = true
    }
    
    func prepareToEndDrawingTap(_ sender: UIButton, _ type: Gesture, _ oriImage: UIImage) {
        sender.self.setImage(oriImage, for: UIControlState.normal)
        sender.self.setTitle("Draw", for: UIControlState.normal)
        self.isDrawing = false
        self.drawStackContainer.isHidden = false
        self.drawStack.isHidden = false
        self.tapBtn.isHidden = false
        self.rectBtn.isHidden = false
        self.lineBtn.isHidden = false
        self.polyBtn.isHidden = false
    }
    
    // Finish drawing saving values before navigation
    func drawFinished(){
        let polyPoint = drawPolygon.pointSelector()
        // Override the Z value
        for point in polyPoint {
            point.coordinate.z = 17
        }
        prepareToCreate(polyPoint)
        self.drawStackContainer.isHidden = false
        self.drawStack.isHidden = false
        self.tapBtn.isHidden = false
        self.rectBtn.isHidden = false
        self.lineBtn.isHidden = false
        self.polyBtn.isHidden = false
    }
    
    // MARK: Can be optimize
    func checkPoints() -> Bool{
        let coordinates: [HDMMapCoordinate] = drawPolygon.coordinates as! [HDMMapCoordinate]
        if coordinates.count == 0 || coordinates.count == 1{
            var message : String?
            if coordinates.count == 0 {message = "Oh no! you need to draw something!"}
            else if coordinates.count == 1 {message = "There is only one point on the map"}
            let alertController = UIAlertController(title: "Not Enough Points Selected", message: message, preferredStyle: .alert)
            
            let confirmButton = UIAlertAction(title: "OK", style: .default) { (_) in
                self.drawPolygon.clear()
            }
    
            alertController.addAction(confirmButton)
            
                self.present(alertController, animated: true, completion: nil)
    
            return false
        }
        return true
    }
    
    func prepareToCreate(_ cPoints: [HDMPoint]){
        var points : [putPlace.Geofence.Points] = []
        var geofencePoints : [setGeofence.Geofence.Points] = []
        // Double Check
        if cPoints.count == 0 || cPoints.count == 1{
            var message : String?
            if cPoints.count == 0 {message = "You have not mark any points on the map"}
            else if cPoints.count == 1 {message = "You have only selected one point on the map"}
            let alertController = UIAlertController(title: "Not Enough Points Selected", message: message, preferredStyle: .alert)
            
            let confirmButton = UIAlertAction(title: "OK", style: .default) { (_) in
                // Add Action after complete
            }
            alertController.addAction(confirmButton)
            
            if !(self.navigationController?.visibleViewController?.isKind(of: UIAlertController.self))! {
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            
            //remember to assign new polygons to array
            let data = DataHandler()
            (self.coordinateX , self.coordinateY) = CoordinateHandler.castPointsToXY(pointsXY: cPoints)
            (points) = data.getPoints(self.coordinateX, self.coordinateY)
            (geofencePoints) = data.getGeofencePoints(self.coordinateX, self.coordinateY)
            

                var shape : String?
                if(points.count == 1) {shape = "RADIAL"}
                else {shape = "POLYGON"}
            
            if status == "geofence"{
                let geofence = setGeofence.Geofence(shape: shape, points: geofencePoints)
                // Swap name with the appropriate name
                let update = setGeofence(geofence: geofence)
                
                data.updateGeofence(update, urlArray[urlIndex!])
                
                let poly = HDMPolygon.init(points: cPoints)
                let zPoint = CoordinateHandler.getHighestZ(cPoints) + 1
                let feature = HDMPolygonFeature.init(polygon: poly, featureType: "poly", zmin: 17 , zmax: 17)
                
                let coordinate = HDMMapCoordinateMake((self.coordinateX[0]+self.coordinateX[2])/2, (self.coordinateY[0]+self.coordinateY[2])/2, zPoint)
                
                let annotation = HDMAnnotation(coordinate: coordinate)
                annotation.title = nameArray[urlIndex!]
                //set annotation name
                
                self.mapView.add(feature)
                self.featureId[urlIndex!] = feature.featureId
                self.feature[urlIndex!] = feature
                self.annotation[urlIndex!] = annotation
                
                //Reset status
                self.status = nil
                
                //after sending data, set points to nil
                points.removeAll()
                
                if self.gestureType == .tap {
                    // Call back the button to reset the button
                    self.tapAction(self.tapBtn)
                }
                
                showPositiveMessage(message: "Successfully update \(nameArray[urlIndex!])'s geofence")
                
            } else {
                
            let geofence = putPlace.Geofence(shape: shape, points: points)
                
            let alertController = UIAlertController(title: "Create Region", message: "Enter a name.", preferredStyle: UIAlertControllerStyle.alert)
                
            let redrawAction = UIAlertAction(title: "Redraw", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                self.tapAction(self.tapBtn)
            }
            let doneAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                
                let nameTextField = alertController.textFields![0] as UITextField
                // Swap Geofence name  with the appropriate beacon
                let bName = data.getBeaconId(beaconName: nameTextField.text!)
                let beacon = [putPlace.Beacons(id: bName)]
                
                // Swap name with the appropriate name
                let create = putPlace(name: nameTextField.text, geofence: geofence, beacons: beacon)
                
                data.createPlace(create,nameTextField.text!)
            
                //after sending data, set points to nil
                points.removeAll()
                
                if self.gestureType == .tap {
                // Call back the button to reset the button
                self.tapAction(self.tapBtn)
                }
            }
            doneAction.isEnabled = false
            alertController.addAction(redrawAction)
            alertController.addAction(doneAction)
            
                alertController.addTextField (configurationHandler: { (textField) in
                    textField.placeholder = "Name"
                    NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                        var uniqueName = true
                        for n in self.nameArray{
                            if textField.text! == n {
                                uniqueName = false
                                break
                            }
                        }
               
                            doneAction.isEnabled = textField.text!.count > 0 && uniqueName
                        
                    }
                })
                
            self.present(alertController, animated: true, completion: nil)
            
            }
        }
    }
    
    // MARK: For new map
    
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

    
    func mapReload() {
        mapView.reloadStyle()
    }
    
    @objc func functionSelector(_ button: UIButton) {
     
    }
    
    
}

