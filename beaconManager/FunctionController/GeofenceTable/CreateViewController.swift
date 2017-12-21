//
//  CreateViewController.swift
//  MultipleHDMMapView
//
//  Created by Tan Chung Shzen on 02.10.17.
//  Copyright © 2017 HDMI. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var beaconIdField: UITextField!
    
    @IBOutlet weak var pickerBeacon: UIPickerView!
    
    @IBOutlet var nameValidationLabel: UILabel!
    @IBOutlet weak var geofenceValidationLabel: UILabel!
    
    @IBOutlet weak var addGeofenceBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    
    var status : String?
     var state : String?
    var points : [putPlace.Geofence.Points]? = nil
    
    let list = ["Bauhaus", "Küche", "B&B B", "Meetingraum Heidelberg", "Geo Dev" ,"Kicker" ,"Glashaus" ,"Matthi" ,"Eingang Entwicklung" ,"Tokio"]
    
    //    MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexString: "#96accf77")
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
    }
    
    fileprivate func setupView() {
        geofenceValidationLabel.isHidden = true
        nameValidationLabel.isHidden = true
        self.pickerBeacon.isHidden = true
    }
    
    //Pass data back to Main using segue unwind
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        status = state
    }
    
    //MARK: Button function
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addGeofence(_ sender: Any) {
        //Save the state while user navigate to another view
        saveStates()
        state = "create" //tell Main to call create function
    }
    
    @IBAction func submitForm(_ sender: Any) {
        state = "" //declare state as nil
        if (nameTextField.text?.isEmpty)! || points == nil{
            self.nameValidationLabel.text = "Please fill in the name"
            self.geofenceValidationLabel.text = "Geofence has not been marked"
            
            if (nameTextField.text?.isEmpty)! {UIView.animate(withDuration: 0.25, animations: {
                self.nameValidationLabel.isHidden = false
            })}
            if points == nil {
                UIView.animate(withDuration: 0.25, animations: {
                    self.geofenceValidationLabel.isHidden = false
            })}
        } else {
            var shape : String?
            let data = DataHandler()
            if points?.count == nil {shape = nil}
            else if(points?.count == 1) {shape = "RADIAL"}
            else {shape = "POLYGON"}
            let geofence = putPlace.Geofence(shape: shape, points: points)
            let beacon = [putPlace.Beacons(id: data.getBeaconId(beaconName: beaconIdField.text!))]
            
            let create = putPlace(name: nameTextField.text, geofence: geofence, beacons: beacon)
            
            data.createPlace(create,nameTextField.text!)
            
            //after sending data, set points to nil
            points = nil
            
            performSegue(withIdentifier: "GeofenceController", sender: nil)
//            let time = DispatchTime.now() + 1.5
//            DispatchQueue.main.asyncAfter(deadline: time) {
//
//                let naviController = UIStoryboard(name: "Main" , bundle: nil).instantiateViewController(withIdentifier: "GeofenceController") as? GeofenceController
//
//                self.navigationController?.pushViewController(naviController!, animated: true)
//            }
        }
    }
}

//MARK: Other functions


//MARK: UITextFieldDelegate
extension CreateViewController: UITextFieldDelegate {
    
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
    
    func textFieldShouldReturn(_ textField: UITextField)-> Bool{
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //updateSaveButtonState()
        textField.resignFirstResponder()
        //navigationItem.title = textField.text
    }
    
}

extension CreateViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
