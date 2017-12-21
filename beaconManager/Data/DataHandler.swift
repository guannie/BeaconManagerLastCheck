//
//  DataHandler.swift
//  MultipleHDMMapView
//
//  Created by Tan Chung Shzen on 22.09.17.
//  Copyright © 2017 HDMI. All rights reserved.
//

import UIKit
import HDMMapCore

class DataHandler : HDMMapViewController, HDMMapViewControllerDelegate {

    let headers = [
        "authorization": "Token token=d56d21be74f8c2256190b681ad43d9f8",
        "content-type": "application/json",
        "cache-control": "no-cache",
        "postman-token": "0017962a-2bc2-cbe3-c65b-38acad6be8da"
    ]
    
    func getBeaconId (beaconName: String) -> (String) {
        
        var beaconId : String?
        
        switch beaconName {
        case "Bauhaus":
            beaconId = "5BA5149904694C61B7E048A33761CFFF"
        case "Küche":
            beaconId = "6862263E3D8046E188A05FDB26BE7264"
        case "B&B B":
            beaconId = "92F96CFDF6034AD580FEBEDBF3E09852"
        case "Meetingraum Heidelberg":
            beaconId = "89F2D6B3338240C1AE42F1BEC2CE544C"
        case "Geo Dev":
            beaconId = "5D71868A35174FD985801E0AD1358A13"
        case "Kicker":
            beaconId = "65C8711F83B7491E98B6839C600F2B3C"
        case "Glashaus":
            beaconId = "357DBCFD80D24DF0AAE6C9D1D4B3DC37"
        case "Matthi":
            beaconId = "559A5BCA9E28442B9CF2D52E96A5EAD3"
        case "Eingang Entwicklung":
            beaconId = "6B1C7DD8A68C46D889C4FB860DAE7F8C"
        case "Tokio":
            beaconId = "06470462D6B74DBC8CDAF18D341ECE9F"
        default:
            beaconId = ""
        }
        
        return beaconId!
    }
    
    func getBeaconFactoryId (beaconName: String) -> (String) {
        
        var beaconId : String?
        
        switch beaconName {
        case "Bauhaus":
            beaconId = "Y1JK-RW1HP"
        case "Küche":
            beaconId = "XWQC-1GHKJ"
        case "B&B B":
            beaconId = "XVPJ-S6MGZ"
        case "Meetingraum Heidelberg":
            beaconId = "XWEG-WR8F5"
        case "Geo Dev":
            beaconId = "XZ7S-F8AYS"
        case "Kicker":
            beaconId = "XYZH-EZU1P"
        case "Glashaus":
            beaconId = "XU1B-2NS54"
        case "Matthi":
            beaconId = "XZ24-RKNA9"
        case "Eingang Entwicklung":
            beaconId = "XW3P-3YWA2"
        case "Tokio":
            beaconId = "XVCT-PZN68"
        default:
            beaconId = ""
        }
        
        return beaconId!
    }
    
    func getPlaceId(completionHandler: @escaping ([String]?)-> Void) {
        
        var placeId : [String] = []
        let urlGimbal = "https://manager.gimbal.com/api/v2/places/"
        
        let url = URL(string: urlGimbal)
        
        var request = URLRequest(url: url!)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = self.headers
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let places = try decoder.decode([Place].self, from: responseData)
                for place in places{
                    placeId.append(place.id)
                }
                completionHandler(placeId)
            } catch {
                print("error trying to convert data to JSON")
                print(error)
            }
        })
        
        task.resume()
    }
    
    func getSpecificPlace(completionHandler: @escaping (placeData?) -> Void) {
        
        getPlaceId(){ (placeId) in
            
        for place in placeId!{
            var latitude : [Double] = []
            var longitude : [Double] = []
            
            
            let url = "https://manager.gimbal.com/api/v2/places/" + String(place)
            
            let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = self.headers
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                guard let responseData = data else {
                    print("Error: did not receive data")
                    return
                }
                guard error == nil else {
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    var beacon = try decoder.decode(getPlace.self, from: responseData)
                    
                    beacon.url = String(place)
                    
                    if (beacon.geofence?.points != nil){
                        let arrays = beacon.geofence?.points
                        for array in arrays!{
                            latitude.append(array.latitude!)
                            longitude.append(array.longitude!)
                        }
                        
                        let coordinate = HDMMapCoordinateMake((latitude[0]+latitude[2])/2, (longitude[0]+longitude[2])/2, 17.1)
                   
                        
                        var ring0 : [Any] = []
                        
                        for (x, y) in zip(latitude, longitude){
                            ring0.append(HDMPoint.init(x, y: y, z: 0))
                        }
                        
                        ring0.append(HDMPoint.init(latitude[0], y: longitude[0],  z: 0))
                        
                        let poly = HDMPolygon.init(points: ring0 as! [HDMPoint])
                        let myFeature: HDMFeature = HDMPolygonFeature.init(polygon: poly, featureType: "poly", zmin: 17, zmax: 17)
                        let annotation = HDMAnnotation(coordinate: coordinate)
                        annotation.title = beacon.name
                        
                        let gPlace = placeData(place: beacon, feature: myFeature, annotation: annotation)
                        
                        completionHandler(gPlace)
                    } else {
                        
                        let gPlace = placeData(place: beacon, feature: nil, annotation: nil)
                        
                        completionHandler(gPlace)
                    }
                    
                    
                } catch {
                    print("error trying to convert data to JSON")
                    print(error)
                }
            })
            
            dataTask.resume()
        }
        }
    }
   
    func getBeacon(completionHandler: @escaping ([Beacon]?) -> Void) {
        
        var beacons : [Beacon] = []
        
        let urlGimbal = "https://manager.gimbal.com/api/beacons/"
        
        let url = URL(string: urlGimbal)
        
        var request = URLRequest(url: url!)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = self.headers
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let datas = try decoder.decode([Beacon].self, from: responseData)
                
                for data in datas{
                    let beacon = Beacon(name: data.name, latitude: data.latitude, longitude: data.longitude, visibility: data.visibility, battery_level: data.battery_level, battery_updated_date: data.battery_updated_date, hardware: data.hardware)
                    
                      beacons.append(beacon)
                }
                
                completionHandler(beacons)
            } catch {
                print("error trying to convert data to JSON")
                print(error)
            }
        })
        
        task.resume()
    }
    
    //MARK: Functions for Sending data to SERVER
    func getPoints(_ x: [Double], _ y: [Double]) -> ([putPlace.Geofence.Points]){
        //For putPlace
        var points : [putPlace.Geofence.Points] = []
        
        // for gimbal server latitude refers to the horizontal line which is y in this case
        if x.count == 2 {
                points.append(putPlace.Geofence.Points(latitude: x[0], longitude: y[0]))
                points.append(putPlace.Geofence.Points(latitude: x[0], longitude: y[1]))
                points.append(putPlace.Geofence.Points(latitude: x[1], longitude: y[1]))
                points.append(putPlace.Geofence.Points(latitude: x[1], longitude: y[0]))
        }
        for (latitude, longitude) in zip(x,y){
            points.append(putPlace.Geofence.Points(latitude: latitude, longitude: longitude))
        }
        return (points)
    }
    
    func getGeofencePoints(_ x: [Double], _ y: [Double]) -> ([setGeofence.Geofence.Points]){
        //For setGeofence
        var points : [setGeofence.Geofence.Points] = []
        
        // for gimbal server latitude refers to the horizontal line which is y in this case
        if x.count == 2 {
            points.append(setGeofence.Geofence.Points(latitude: x[0], longitude: y[0]))
            points.append(setGeofence.Geofence.Points(latitude: x[0], longitude: y[1]))
            points.append(setGeofence.Geofence.Points(latitude: x[1], longitude: y[1]))
            points.append(setGeofence.Geofence.Points(latitude: x[1], longitude: y[0]))
        }
        for (latitude, longitude) in zip(x,y){
            points.append(setGeofence.Geofence.Points(latitude: latitude, longitude: longitude))
        }
        return (points)
    }
    
    func createPlace(_ create: putPlace, _ name: String){
        
        
        let postData = try! JSONEncoder().encode(create)
        print(String(data:postData, encoding: .utf8)!)
        let request = NSMutableURLRequest(url: NSURL(string: "https://manager.gimbal.com/api/v2/places/")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!)
                
                //Call to confirmCreate only when upload is successful
                if(httpResponse?.statusCode == 200){
                    //notify to confirmCreate
                    let data = ["name" : name]
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "confirmCreate"), object: nil, userInfo: data)
                    
                    //notify to insertRegionRow
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "insertRegionRow"), object: nil, userInfo: data)
                    
                }else{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "alertError"), object: nil, userInfo: nil)
                }
            }
        })
        
        dataTask.resume()
        
    }
    
    func updatePlace(_ updates: putPlace, _ url: String){
        
        let postData = try! JSONEncoder().encode(updates)
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://manager.gimbal.com/api/v2/places/" + String(url))! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        print(String(data:postData, encoding: .utf8)!)
        
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = self.headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "Fail to get error message")
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse ?? "Fail to get response")
                
                //Call to confirmUpdate only when upload is successful
//                if(httpResponse?.statusCode == 200){
//                    let data = ["url" : url]
//
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "confirmUpdate"), object: nil, userInfo: data)
//                }else{
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "alertError"), object: nil, userInfo: nil)
//                }
            }
        })
        dataTask.resume()
    }
    
    func updateGeofence(_ updates: setGeofence, _ url: String){
        
        let postData = try! JSONEncoder().encode(updates)
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://manager.gimbal.com/api/v2/places/" + String(url))! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        print(String(data:postData, encoding: .utf8)!)
        
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = self.headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "Fail to get error message")
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse ?? "Fail to get response")
            }
        })
        dataTask.resume()
    }
    
    func deletePlace(_ url: String){
        
        //notify to deletebeacon
        let data = ["url" : url]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteGeofence"), object: nil, userInfo: data)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteRegionRow"), object: nil, userInfo: data)
        
        //notify to deleteAllBeaconRow
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteAllBeaconRow"), object: nil, userInfo: nil)
      
        let request = NSMutableURLRequest(url: NSURL(string: "https://manager.gimbal.com/api/v2/places/" + String(url))! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = self.headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (_, response, error) -> Void in
            if (error != nil) {
                print(error ?? "Fail to get error message")
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse ?? "Fail to get response")
            }
        })
        
        dataTask.resume()
        
    }
    
    func updateBeaconCoordinate(_ data: Beacon){
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://manager.gimbal.com/api/beacons/" + data.id!)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        let postData = try! JSONEncoder().encode(data)
        
        print(String(data:postData, encoding: .utf8)!)
        
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = self.headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "Fail to get error message")
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse ?? "Fail to get response")
            }
        })
        dataTask.resume()
    }
}
    

