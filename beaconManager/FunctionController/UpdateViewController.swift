//
//  UpdateViewController.swift
//  MultipleHDMMapView
//
//  Created by Tan Chung Shzen on 27.09.17.
//  Copyright © 2017 HDMI. All rights reserved.
//

import UIKit

class UpdateViewController: UIViewController {
    //    MARK: Properties
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var beaconIdField: UITextField!
    
    @IBOutlet weak var pickerBeacon: UIPickerView!
    
    @IBOutlet var nameValidationLabel: UILabel!
    
    @IBOutlet weak var editGeofenceBtn: UIButton!
    
    @IBOutlet weak var updateBtn: UIButton!
    
    var name: String = ""
    var beaconId: String = ""
    var url: String = ""
    var urlMain: String?
    var status: String?
    var points : [putPlace.Geofence.Points]? = nil
    let list = ["Bauhaus", "Küche", "B&B B", "Meetingraum Heidelberg", "Geo Dev" ,"Kicker" ,"Glashaus" ,"Matthi" ,"Eingang Entwicklung" ,"Tokio"]
  
    //    MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !name.isEmpty{
            nameTextField.text = name
        }
        if !beaconId.isEmpty{
            beaconIdField.text = beaconId
        }
       // beaconIdField.autocapitalizationType = .allCharacters
        setupView()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if status == "load" {
            loadStates()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated) // No need for semicolon
        status = ""
    }
    
    fileprivate func setupView() {
        nameValidationLabel.isHidden = true
        self.pickerBeacon.isHidden = true
    }
    
    //passing data back to Main using segue unwind
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        status = "update"
        urlMain = url
    }
    
    //MARK: Button functions
    @IBAction func editGeofence(_ sender: UIButton) {
        //Save the state while user navigate to another view
        saveStates()
    }
    
    @IBAction func updateForm(_ sender: Any) {
            let data = DataHandler()
            var shape = "POLYGON"
            if(points?.count == 1) {shape = "Radial"}
        
            let geofence = putPlace.Geofence(shape: shape, points: points)
            let beacon = [putPlace.Beacons(id: data.getBeaconId(beaconName: beaconIdField.text!))]
        
            let updates = putPlace(name: nameTextField.text, geofence: geofence, beacons: beacon)
        
            data.updatePlace(updates,url)
        
            performSegue(withIdentifier: "UpdatetoGeofence", sender: nil)
        
    }
}

//MARK: Other functions
extension UpdateViewController: UITextFieldDelegate {
    
    func saveStates(){
        let defaults = UserDefaults.standard
        
        defaults.set(nameTextField.text, forKey: "nameTextField")
        defaults.set(beaconIdField.text, forKey: "beaconIdField")
        defaults.synchronize()
    }
    
    func loadStates(){
        let defaults = UserDefaults.standard
        
        nameTextField.text = defaults.object(forKey: "nameTextField") as? String
        beaconIdField.text = defaults.object(forKey: "beaconIdField") as? String
    }
}

extension UpdateViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.beaconIdField.text = self.list[row]
        self.pickerBeacon.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.beaconIdField{
            self.pickerBeacon.isHidden = false
            
            textField.endEditing(true)
        }
    }
    
}

