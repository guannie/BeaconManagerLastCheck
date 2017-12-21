//
//  BeaconController.swift
//  beaconManager
//
//  Created by Tan Chung Shzen on 17.10.17.
//  Copyright © 2017 HDMI. All rights reserved.
//

import UIKit

class BeaconController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var url : String?
    var beaconName = [String] ()
    var latitude = [Double] ()
    var longitude = [Double] ()
    var visibility = [String] ()
    var battery_level = [String] ()
    var battery_updated = [String] ()
    var hardware = [String] ()
    var existingBeacons = [String] ()
    var index : IndexPath?
    var vc : String? //this variable is use to track if the user is selecting other region when the beaconselector is currently the view. If the user select other region while the 2nd view is still in the beaconselector, it will be pop.
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBtn: UIBarButtonItem!
    
    @IBAction func slideIn(_ sender: Any) {
        //Hide Beacon Table
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideBeacon"), object: nil)
    }
    
    @IBAction func actionAddBtn(_ sender: Any) {
        if url == nil {
            
            showPositiveMessage(message: "Select a region to start adding beacons")
            
        } else {
            let vc = BeaconSelector()
            vc.setBeaconInfo(url!,beaconName,existingBeacons)
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vc = "BeaconController"
        self.title = "Beacon"
        self.view.backgroundColor = UIColor(hexString: "#96accf77")
        
        //get all the existing beacons
        let data = DataHandler()
        data.getSpecificPlace(){
            (place) in
            
            if !((place?.place?.beacons?.isEmpty)!){
                for beacon in (place?.place?.beacons)! {
                    self.existingBeacons.append(beacon.name!)
                }
            }
        }
        
        //observer of reloadTable
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTable(_:)), name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
        
        //observer of reloadTableCell
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableCell(_:)), name: NSNotification.Name(rawValue: "reloadTableCell"), object: nil)
        
        //observer of insertRow
        NotificationCenter.default.addObserver(self, selector: #selector(self.insertRow(_:)), name: NSNotification.Name(rawValue: "insertRow"), object: nil)
        
        //observer of deleteRow
        NotificationCenter.default.addObserver(self, selector: #selector(self.deleteRow(_:)), name: NSNotification.Name(rawValue: "deleteRow"), object: nil)
        
        //observer of deleteAllBeaconRow
        NotificationCenter.default.addObserver(self, selector: #selector(self.deleteAllBeaconRow(_:)), name: NSNotification.Name(rawValue: "deleteAllBeaconRow"), object: nil)
        
        let nibName = UINib(nibName: "beaconCustomCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "beaconCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
        vc = "BeaconController" //set viewcontroller status to BeaconController
        print("Beacon will Appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        vc = "BeaconSelector" //set viewcontroller status to BeaconSelector
        print("Beacon did disappear")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.beaconName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : beaconCustomCell = tableView.dequeueReusableCell(withIdentifier: "beaconCell", for: indexPath) as! beaconCustomCell
        
        if !(beaconName[0] == "") {
            cell.customInit(self.beaconName[indexPath.row], lat: self.latitude[indexPath.row], long: self.longitude[indexPath.row], vis: self.visibility[indexPath.row], bl: self.battery_level[indexPath.row], bu: self.battery_updated[indexPath.row], hardw: self.hardware[indexPath.row])
        }
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        

        let editAction = UITableViewRowAction(style: .normal, title: "Set Coordinate", handler: { (action, indexPath) in
            
            self.index = IndexPath(item: indexPath.row, section: 0)
            
            let data = ["name" : self.beaconName[indexPath.row], "status" : "beacon", "url" : self.url ?? ""] as [String : Any]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getBeaconCoordinate"), object: nil, userInfo: data)
        })
        //editAction.backgroundColor = UIColor.blue
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
            
            let i = indexPath.row
            
            let index = IndexPath(item : indexPath.row, section: 0)
            
            let info = ["name": self.beaconName[indexPath.row], "url": self.url] as! [String:String]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeBeaconArray"), object: nil, userInfo: info)
            
            if let j = self.existingBeacons.index(of: self.beaconName[i]){
                self.existingBeacons.remove(at: j)
            }
            self.beaconName.remove(at: i)
            self.latitude.remove(at: i)
            self.longitude.remove(at: i)
            self.visibility.remove(at: i)
            self.battery_level.remove(at: i)
            self.battery_updated.remove(at: i)
            self.hardware.remove(at: i)
            
            let data = DataHandler()
            
            var beacons = [putPlace.Beacons]()
            
            if self.beaconName.count == 1{
                let beacon = putPlace.Beacons.init(id: "")
                beacons.append(beacon)
            } else {
                for i in self.beaconName{
                    let beacon = putPlace.Beacons.init(id: data.getBeaconId(beaconName: i))
                    beacons.append(beacon)
                }
            }
            
            let updates = putPlace(beacons: beacons)
            
            data.updatePlace(updates, self.url!)
            
            tableView.deleteRows(at: [index], with: UITableViewRowAnimation.fade)
        })
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    //Insert a new row to the table
    @objc func insertRow(_ notification: NSNotification){
      if let name = notification.userInfo?["name"] as! String?{
        self.existingBeacons.append(name)
        
        let data = DataHandler()
        data.getBeacon(){
            (beacons) in
            for beacon in beacons!{
                if name == beacon.name{
                    self.beaconName.append(beacon.name!)
                    self.latitude.append(beacon.latitude!)
                    self.longitude.append(beacon.longitude!)
                    self.visibility.append(beacon.visibility!)
                    self.battery_level.append(beacon.battery_level!)
                    self.battery_updated.append(beacon.battery_updated_date!)
                    self.hardware.append(beacon.hardware!)
                    
                    let data = ["name" : beacon.name!, "url": self.url] as! [String:String]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBeaconArray"), object: nil, userInfo: data)
                }
            }
            DispatchQueue.main.async {
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: self.beaconName.count - 1, section: 0)], with: UITableViewRowAnimation.automatic)
                self.tableView.endUpdates()
            }
        }
      }
    }
    
    //Delete selected Row
    @objc func deleteRow(_ notification: NSNotification){
         if let name = notification.userInfo?["name"] as! String?{
            if let i = beaconName.index(of: name){
                if let j = self.existingBeacons.index(of: self.beaconName[i]){
                    self.existingBeacons.remove(at: j)
                }
                
                beaconName.remove(at: i)
                latitude.remove(at: i)
                longitude.remove(at: i)
                visibility.remove(at: i)
                battery_level.remove(at: i)
                battery_updated.remove(at: i)
                hardware.remove(at: i)
                
                tableView.deleteRows(at: [index!], with: UITableViewRowAnimation.automatic)
                let data = ["name": name, "url": self.url] as! [String:String]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeBeaconArray"), object: nil, userInfo: data)
            }
        }
    }
    
    //Remove all beacons that are associated with the deleted region
    @objc func deleteAllBeaconRow(_ notification: NSNotification){
        //remove all the beacons from the region that has been removed from the existingBeacons
        for b in beaconName{
            if let i = existingBeacons.index(of: b){
                existingBeacons.remove(at: i)
            }
        }
                beaconName.removeAll()
                latitude.removeAll()
                longitude.removeAll()
                visibility.removeAll()
                battery_level.removeAll()
                battery_updated.removeAll()
                hardware.removeAll()
        
                tableView.reloadData()
    }
    
    @objc func reloadTableCell(_ notification: NSNotification){
        
        if let name = notification.userInfo?["name"] as! String?{
            if let i = beaconName.index(of: name ){
                if let beaconX = notification.userInfo?["beaconX"] as! Double?{longitude[i] = beaconX}
                if let beaconY = notification.userInfo?["beaconY"] as! Double?{latitude[i] = beaconY}
            }
        }
        tableView.reloadRows(at: [index!], with: .top)
    }
    
    //This function reloads the table in 2nd view to show the selected region's beacons
    @objc func reloadTable(_ notification: NSNotification){
        
        beaconName.removeAll()
        latitude.removeAll()
        longitude.removeAll()
        visibility.removeAll()
        battery_level.removeAll()
        battery_updated.removeAll()
        hardware.removeAll()
        
        if !(vc == "BeaconController"){navigationController?.popViewController(animated: true)}
        
        if let url = notification.userInfo?["url"] as? String{self.url = url}
        if let beaconName : [String] = notification.userInfo?["beacon"] as? [String]{
       
        if !(beaconName.isEmpty || beaconName[0] == ""){
            self.beaconName = beaconName
    
        let data = DataHandler()
        data.getBeacon(){
            (beacons) in
            
            for beacon in beacons!{
                for bn in self.beaconName{
                    if bn == beacon.name!{
                        self.latitude.append(beacon.latitude!)
                        self.longitude.append(beacon.longitude!)
                        self.visibility.append(beacon.visibility!)
                        self.battery_level.append(beacon.battery_level!)
                        self.battery_updated.append(beacon.battery_updated_date!)
                        self.hardware.append(beacon.hardware!)
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
      }
        else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
          }
       }
    }
    
}


