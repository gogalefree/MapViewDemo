//
//  MDEvent.swift
//  MapViewDemo
//
//  Created by Guy Freedman on 10/15/14.
//  Copyright (c) 2014 Guy Freeman. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

enum TypeOfCollecting: Int{
    case FreePickup = 0, ContactPublisher = 1
}

public class MDEvent: NSObject , MKAnnotation {

    public var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    public var title: String = ""
    public var subtitle: String = ""
    public var distanceFromUserLocation: Double? {
            let eventLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            return eventLocation.distanceFromLocation(MDModel.sharedInstance.userLocation)
    }
        var eventAddress = ""
        var startingDate = ""
        var endingDate = ""
        var photo: UIImage = UIImage()
        var theTypeOfCollecting = TypeOfCollecting.FreePickup
    
    
    public init(annLocation: CLLocation, annTitle: String?, annSubtitle: String?) {
        coordinate = annLocation.coordinate
        title = annTitle ?? ""
        subtitle = annSubtitle ?? ""
        super.init()
    }
}

class MDPinAnnotationViewFactory {
    
    class func pinAnnotationViewForAnnotation
        (annotation: MKAnnotation, reuseableId: String) -> MKPinAnnotationView {
    
            var pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseableId)
            pinView.pinColor = MKPinAnnotationColor.Red
            pinView.enabled = true
            pinView.canShowCallout = true
            pinView.animatesDrop = true
            pinView.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIView

            return pinView
    }
}
