//
//  MDModel.swift
//  MapViewDemo
//
//  Created by Guy Freedman on 10/15/14.
//  Copyright (c) 2014 Guy Freeman. All rights reserved.
//

import UIKit
import CoreLocation

class MDModel: NSObject, CLLocationManagerDelegate {

    var ios8 : Bool {
        if ((UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0){
            return true
            }
        return false
    }

    let kDistanceFilter = 10.0
    var annotationsToPresent = [MDEvent]()
    let locationManager = CLLocationManager()
    var userLocation = CLLocation()
    
     override init() {
        super.init()
        setup()
    }
    
    func setup() {
    
        let loc1 = CLLocation(latitude: 32.357868, longitude: 34.934164)
        let loc2 = CLLocation(latitude: 32.361233, longitude: 34.867452)
        let loc3 = CLLocation(latitude: 32.381214, longitude: 34.882611)
    
        let ann1 = MDEvent(annLocation: loc1, annTitle: "Guy's house",
        annSubtitle:"beit halevy")
        let ann2 = MDEvent(annLocation: loc2, annTitle: "Coffee Neto", annSubtitle: nil)
        let ann3 = MDEvent (annLocation: loc3, annTitle: "Shabtai Pizza", annSubtitle: nil)
       
        annotationsToPresent.append(ann1)
        annotationsToPresent.append(ann2)
        annotationsToPresent.append(ann3)

        
        if ios8 {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kDistanceFilter
        locationManager.startUpdatingLocation()
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        userLocation = locations.first as CLLocation
    }

}

extension MDModel {
    //SingleTone Shared Instance
    class var sharedInstance : MDModel {
        
    struct Static {
        static var onceToken : dispatch_once_t = 0
        static var instance : MDModel? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = MDModel()
        }
        return Static.instance!
    }
}
