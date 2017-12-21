//
//  MainContainerViewController.swift
//  beaconManager
//
//  Created by Lee Kuan Xin on 19.10.17.
//  Copyright © 2017 HDMI. All rights reserved.
//

import UIKit

class MainContainerViewController: UIViewController {

    @IBOutlet weak var placeList: UIView!
    @IBOutlet weak var beaconList: UIView!
    @IBOutlet weak var map: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //observer of showBeacon
        NotificationCenter.default.addObserver(self, selector: #selector(self.showBeacon(_:)), name: NSNotification.Name(rawValue: "showBeacon"), object: nil)
        //observer of hideBeacon
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideBeacon(_:)), name: NSNotification.Name(rawValue: "hideBeacon"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: View Management
    func showBeaconList() {
        if beaconList.isHidden == true{
        let f = beaconList.frame
        map.frame = CGRect(x: f.maxX, y: 0, width: (map.frame.width - f.width), height: map.frame.height)
        beaconList.isHidden = false
        }
    }
    
    func hideBeaconsList() {
        if beaconList.isHidden == false{
        let f = beaconList.frame
        map.frame = CGRect(x: f.minX, y: f.minY, width: (view.frame.maxX-f.minX), height: map.frame.height)
        print(map.frame)
        beaconList.isHidden = true
            //= CGRect(x: f.minX, y: f.minY, width: 0, height: f.height)
        }
    }
    
    @IBAction func toggle(_ sender: Any) {
        beaconList.isHidden ? showBeaconList(): hideBeaconsList()
    }
    
    // MARK: Setup View to Display
    func setupView() {
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func showBeacon(_ notification: NSNotification){
        showBeaconList()
    }
    
    @objc func hideBeacon(_ notification: NSNotification){
        print("HERE")
        hideBeaconsList()
    }

}


