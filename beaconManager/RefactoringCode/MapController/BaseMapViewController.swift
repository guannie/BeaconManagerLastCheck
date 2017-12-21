//
//  BaseMapViewController.swift
//  BeaconViewer
//
//  Created by Lee Kuan Xin on 17.10.17.
//  Copyright © 2017 HDMI. All rights reserved.
//

import UIKit
import HDMMapCore

protocol ControllerType {
    var mapViewController:HDMMapViewController! { get set }
    
    func configureMap()
    func setVisibleMapRegion(mapRegion:HDMMapRegion, animated animate:Bool)
}

class BaseMapViewController: UIViewController, ControllerType, HDMMapViewControllerDelegate {
    var mapViewController: HDMMapViewController!
    
    func configureMap() {
        mapViewController.mapView.showsCompass = true
        mapViewController.mapView.set3DMode(false, animated: true)
        mapViewController.mapView.setFeatureStyle("poly", propertyName: "fill-color", value: "#e9bc00")
        mapViewController.mapView.reloadStyle()
        mapViewController.mapView.moveToFeature(withId: 19392, animated: false)
        
        // For user interaction
        mapViewController.mapView.rotateEnabled = false
        mapViewController.mapView.tiltEnabled = false
    }
    
    func setVisibleMapRegion(mapRegion: HDMMapRegion, animated animate: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.autoresizesSubviews = true
        view.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapViewController?.delegate = self
        let size = view.frame.size
        mapViewController?.view.frame = CGRect(x: 0, y: 0, width: size.width , height: size.height)
        mapViewController?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview((mapViewController?.view)!)
        addChildViewController((mapViewController)!)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapViewController?.removeFromParentViewController()
        mapViewController?.view.removeFromSuperview()
    }
    
    func shouldAutorotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation)-> Bool{
        return true
    }
    
    func mapViewControllerDidStart(_ controller: HDMMapViewController, error: Error?) {
        print("Map start error:  \(String(describing: error))")
        configureMap()
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

