//
//  GeofenceController.swift
//  MultipleHDMMapView
//
//  Created by Lee Kuan Xin on 22.09.17.
//  Copyright © 2017 HDMI. All rights reserved.
//

import UIKit
import HDMMapCore

class GeofenceController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var nameArray = [String] ()
    var beaconNameArrays = [[String]] ()
    var beaconNameArray = [String] ()
    var urlArray = [String] ()
    var status = false
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.textLabel?.font = UIFont(name: "Times New Roman", size: (cell.textLabel?.font.pointSize)!)
        cell.textLabel?.text = self.nameArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nameArray.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .normal, title: "Set Geofence", handler: { (action, indexPath) in

            let data = ["url" : self.urlArray[indexPath.row]]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateGeofence"), object: nil, userInfo: data)
        })
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
            let i = indexPath.row
            let data = DataHandler()
            data.deletePlace(self.urlArray[i])
        })
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Show Beacon Table
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showBeacon"), object: nil)
        
        //Display beacons
        let data = ["beacon" : beaconNameArrays[indexPath.row], "url" : urlArray[indexPath.row]] as [String : Any]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil, userInfo: data)
        
        //call moveToRegion
        let data2 = ["url" : urlArray[indexPath.row]]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "moveToRegion"), object: nil, userInfo: data2)
    }
    
    @IBAction func addbtn(_ sender: UIBarButtonItem) {
        //navigationController?.popViewController(animated: true)
    }
    
    @objc func updateBeaconArray(_ notification: NSNotification){
        let name = notification.userInfo?["name"] as! String?
        if let url = notification.userInfo?["url"] as! String?{
            if let i = urlArray.index(of: url){
                if !(beaconNameArrays[i].indices.contains(0)){
                    beaconNameArrays[i].append(name!)
                }else{
                    if (beaconNameArrays[i][0] == "" || beaconNameArrays[i].isEmpty){
                        beaconNameArrays[i][0] = name!
                    }else{
                        beaconNameArrays[i].append(name!)
                    }
                }
            }
        }
    }
    
    @objc func removeBeaconArray(_ notification: NSNotification){
        let name = notification.userInfo?["name"] as! String?
        if let url = notification.userInfo?["url"] as! String?{
            if let i = urlArray.index(of: url){
                if let j = beaconNameArrays[i].index(of: name!){
                    beaconNameArrays[i].remove(at: j)
                }
            }
        }
    }
    
    @objc func insertRegionRow(_ notification: NSNotification){
        if let name = notification.userInfo?["name"] as! String?{
            let data = DataHandler()
            data.getSpecificPlace(){
                (place) in
                if name == place?.place?.name{
                   
                    self.nameArray.append((place?.place?.name)!)
                    self.urlArray.append((place?.place?.url)!)
                    if !((place?.place?.beacons?.isEmpty)!){
                        for beacon in (place?.place?.beacons)! {
                            self.beaconNameArray.append(beacon.name!)
                        }
                    } else {
                        self.beaconNameArray.append("")
                    }
                self.beaconNameArrays.append(self.beaconNameArray)
                self.beaconNameArray.removeAll()
                self.status = false
                
                    DispatchQueue.main.async {
                        self.tableView.beginUpdates()
                        self.tableView.insertRows(at: [IndexPath(row: self.nameArray.count - 1, section: 0)], with: UITableViewRowAnimation.automatic)
                        self.tableView.endUpdates()
                    }
                }
            }
        }
    }
    
    @objc func deleteRegionRow(_ notification: NSNotification){
        if let url = notification.userInfo?["url"] as! String?{
            if let i = urlArray.index(of: url){
                nameArray.remove(at: i)
                urlArray.remove(at: i)
                beaconNameArrays[i].removeAll()
                let index = IndexPath(item: i, section: 0)
                tableView.deleteRows(at: [index], with: UITableViewRowAnimation.automatic)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Region"
        
        let testdata = DataHandler()
        testdata.getSpecificPlace(){
            (place) in
  
            self.nameArray.append((place?.place?.name)!)
            self.urlArray.append((place?.place?.url)!)
 
            if !((place?.place?.beacons?.isEmpty)!){
                for beacon in (place?.place?.beacons)! {
                    self.beaconNameArray.append(beacon.name!)
                }
            } else {
                self.beaconNameArray.append("")
            }
            
          
            self.beaconNameArrays.append(self.beaconNameArray)
            self.beaconNameArray.removeAll()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        //observer of removeBeaconArray
        NotificationCenter.default.addObserver(self, selector: #selector(self.removeBeaconArray(_:)), name: NSNotification.Name(rawValue: "removeBeaconArray"), object: nil)
        
        //observer of updateBeaconArray
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateBeaconArray(_:)), name: NSNotification.Name(rawValue: "updateBeaconArray"), object: nil)
        
        //observer of insertRegionRow
        NotificationCenter.default.addObserver(self, selector: #selector(self.insertRegionRow(_:)), name: NSNotification.Name(rawValue: "insertRegionRow"), object: nil)
        
        //observer of deleteRegionRow
        NotificationCenter.default.addObserver(self, selector: #selector(self.deleteRegionRow(_:)), name: NSNotification.Name(rawValue: "deleteRegionRow"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.tableView.addSubview(self.refreshControl)
    }
}

