//
//  MapVC.swift
//  MapViewDemo
//
//  Created by Guy Freedman on 10/14/14.
//  Copyright (c) 2014 Guy Freedman. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapVC: UIViewController, MKMapViewDelegate, EventDetailsViewDelegate, EventsTableViewDelegate, UIActionSheetDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var showTableButton: UIBarButtonItem!
    
    let model = MDModel.sharedInstance
    var eventDetailsView : EventDetailsView?
    var eventDetailsViewHidden = true
    var eventToNavigate : MDEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        // Localized String
        self.title = NSLocalizedString("Collect", comment: "Title for Map view")
    }
    
    func setUp() {
        
        mapView.delegate = self
        mapView.addAnnotations(model.annotationsToPresent)
        mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        self.view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.view.autoresizesSubviews = true
        
        eventDetailsView = EventDetailsView(frame: self.view.bounds)
        eventDetailsView?.delegate = self
        eventDetailsView!.buttom(0)
        mapView.addSubview(eventDetailsView!)
        
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!,
        calloutAccessoryControlTapped control: UIControl!) {
        
        if !self.eventDetailsViewHidden{
            self.hideEventDetailsView()
        }
        else {
            let event = view.annotation as MDEvent
            self.presentEventDetailsViewForEvent(event)
        }
    }
    
    func hideEventDetailsView() {
  
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            let buttomPoint: CGFloat = CGRectGetMinY(self.view.frame as CGRect!)
            self.eventDetailsView?.buttom(buttomPoint)
            }) { (completion: Bool) -> Void in
                
                self.eventDetailsViewHidden = true
                self.eventDetailsView?.prepareForReuse()
            }        
    }
    
    func presentEventDetailsViewForEvent (anEvent: MDEvent) {

        UIView.animateWithDuration(0.2, animations: { () -> Void in
            let topPoint = CGRectGetMaxY(self.navigationController?.navigationBar.frame as CGRect!)
            self.eventDetailsView?.top(topPoint)
            }){ (completion: Bool) -> Void in
                self.eventDetailsView?.setUpWithEvent(anEvent)
                self.eventDetailsViewHidden = false
        }
        
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {

        if (annotation.isKindOfClass(MKUserLocation)) {
            return nil;
        }
        
        var view : MKPinAnnotationView?
        let reusableId = "pinView"
        
        view = mapView.dequeueReusableAnnotationViewWithIdentifier(reusableId) as? MKPinAnnotationView
        
        if view == nil {
            view = MDPinAnnotationViewFactory.pinAnnotationViewForAnnotation(annotation, reuseableId: reusableId)
        }
        
        return view
    }
   
    func mapView(mapView: MKMapView!, regionWillChangeAnimated animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if !self.eventDetailsViewHidden {
            self.hideEventDetailsView()
        }
    }
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        println("did change region")

    }
    
    @IBAction func showTableViewAction(sender: AnyObject) {

        if !self.eventDetailsViewHidden {
            hideEventDetailsView()
        }

        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let tableVC = self.storyboard?.instantiateViewControllerWithIdentifier("eventsTableVC") as MDEventsTableVC
        tableVC.delegate = self
        self.navigationController!.pushViewController(tableVC, animated: true)
    }

    //called by the eventsDetailView Cancel Button via delegate
    func eventDetailsViewDidDissmiss() {
        self.hideEventDetailsView()
    }
    
    //called by the eventsDetailView Nav Button via delegate
    func eventDetailsViewdidRequestNavigationToEvent (anEvent: MDEvent) {
        
        self.eventToNavigate = anEvent
        
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"waze://")!)) {
            //show action sheet with waze and apple maps
            
            // Localized String
            let actionSheet: UIActionSheet = UIActionSheet(title: NSLocalizedString("Take me with:", comment: "Asks the user to select his preferred navigation app"), delegate: self, cancelButtonTitle: NSLocalizedString("Cancel", comment: "Cancel button"), destructiveButtonTitle: nil, otherButtonTitles: "Waze", "Apple Maps")
            
            actionSheet.showInView(self.view)
        }
        else{
            //navigate with apple maps
            appleMapsNavigation(anEvent)
        }
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        println("\(buttonIndex)")
        
        if (buttonIndex==1) {
            self.wazeNavigation(self.eventToNavigate!)
        }
        else if (buttonIndex==2){
            self.appleMapsNavigation(self.eventToNavigate!)
        }
    }
    
    func wazeNavigation(event: MDEvent){
        
        if UIApplication.sharedApplication().canOpenURL(NSURL(string:"waze://")!){
            
            let navString = "waze://?ll=\(event.coordinate.latitude),\(event.coordinate.longitude)&navigate=yes"
            UIApplication.sharedApplication().openURL(NSURL(string:"waze://")!)
        }
    }
    
    func appleMapsNavigation(anEvent: MDEvent) {
        
        let destinationPM = MKPlacemark(coordinate: anEvent.coordinate, addressDictionary: nil)
        let destinationItem = MKMapItem(placemark: destinationPM)
        destinationItem.name = anEvent.title
        
        let currentPM = MKPlacemark(coordinate: MDModel.sharedInstance.userLocation.coordinate, addressDictionary: nil)
        let currentItem = MKMapItem(placemark: currentPM)
        currentItem.name = "You're Here"
        
        let navItems = [currentItem , destinationItem]
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        
        MKMapItem.openMapsWithItems(navItems, launchOptions: launchOptions)
    }


    //called by the eventTableViewVC at didSelectRowAtIndexPath via delegate
    func didSelectEvent(anEvent: MDEvent) {
        self.presentEventDetailsViewForEvent(anEvent)
        let newRegion = MKCoordinateRegion(center: anEvent.coordinate, span: self.mapView.region.span)
        self.mapView.setRegion(newRegion , animated: true)
    }
}

