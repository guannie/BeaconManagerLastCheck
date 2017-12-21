//
//  BeaconSelector.swift
//  beaconManager
//
//  Created by Tan Chung Shzen on 20.10.17.
//  Copyright © 2017 HDMI. All rights reserved.
//

import UIKit

class BeaconSelector: UIViewController {

    var beacons = [String]()
    var url : String?
    var names : [String]?
    var existingBeacons: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hexString: "#96accf77")
        
        let data = DataHandler()
        data.getBeacon(){
            (beacon) in
            
            if (self.existingBeacons?.isEmpty)!{
                for b in beacon!{
                self.beacons.append(b.name!)
                    }
                }
            
            var status = false
            for b in beacon!{
                for n in self.existingBeacons!{
                    if n == b.name {
                        status = false
                        break
                    } else { status = true}
                }
                if status {self.beacons.append(b.name!)}
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            var buttonY: CGFloat = 200// our Starting Offset, could be 0
            for b in self.beacons {
                
                let beaconBtn = UIButton(frame: CGRect(x: 20, y: buttonY, width: 200, height: 30))
                buttonY = buttonY + 50
                
                beaconBtn.layer.cornerRadius = 10
                beaconBtn.backgroundColor = UIColor(hexString: "#537fbbff")
                beaconBtn.setTitle((b), for: UIControlState.normal)
                beaconBtn.titleLabel?.font = UIFont(name: "Times New Roman", size: (beaconBtn.titleLabel?.font.pointSize)!)
                beaconBtn.titleLabel?.text = "\(b)"
                beaconBtn.addTarget(self, action: #selector(self.respondBtn(sender:)), for: UIControlEvents.touchUpInside)
                
                self.view.addSubview(beaconBtn)  // myView in this case is the view you want these buttons added
            }
        }
        
    }
    
    func setBeaconInfo(_ url: String, _ names: [String], _ existingBeacons: [String]){
        self.url = url
        self.names = names
        self.existingBeacons = existingBeacons
    }
    
    @objc func respondBtn(sender:UIButton!){
        
        let name = sender.titleLabel?.text as! String
        let data = DataHandler()
        var beacons = [putPlace.Beacons]()
        
        for i in names!{
            let beacon = putPlace.Beacons.init(id: data.getBeaconId(beaconName: i))
            beacons.append(beacon)
        }
        
        beacons.append(putPlace.Beacons(id: data.getBeaconId(beaconName: name)))
        let updates = putPlace(beacons: beacons)
        
        data.updatePlace(updates, url!)
        
        let info = ["name" : name]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "insertRow"), object: nil, userInfo: info)
       
        navigationController?.popViewController(animated: true)
    }

}

