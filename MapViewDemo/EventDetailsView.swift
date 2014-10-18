//
//  EventDetailsView.swift
//  MapViewDemo
//
//  Created by Guy Freedman on 10/16/14.
//  Copyright (c) 2014 Guy Freeman. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol EventDetailsViewDelegate {
    func eventDetailsViewDidDissmiss()
    func eventDetailsViewdidRequestNavigationToEvent (anEvent: MDAnnotation)
}

class EventDetailsView: UIView , UIActionSheetDelegate {

    var event: MDAnnotation?
    var accumaltingHeight : CGFloat = 5
    let labelsMargin: CGFloat = 10
    let labelsOriginX: CGFloat = 10
    var delegate : EventDetailsViewDelegate?

    
    func setUpWithEvent (anEvent: MDAnnotation) {

        self.event = anEvent
        self.backgroundColor = UIColor.whiteColor()
        
        let titleLable = UILabel(frame: self.bounds)
        titleLable.text = self.event?.title ?? ""
        titleLable.font = UIFont.systemFontOfSize(20)
        titleLable.textAlignment = NSTextAlignment.Left
        titleLable.numberOfLines = 0
        titleLable.sizeToFit()
        titleLable.frame.origin = CGPointMake(labelsOriginX, accumaltingHeight)
        self.addSubview(titleLable)
        
        accumaltingHeight += CGRectGetHeight(titleLable.bounds) + labelsMargin
        
        let subTitleLable = UILabel(frame: self.bounds)
        subTitleLable.text = self.event?.subtitle ?? ""
        subTitleLable.font = UIFont.systemFontOfSize(16)
        subTitleLable.textAlignment = NSTextAlignment.Left
        subTitleLable.numberOfLines = 0
        subTitleLable.sizeToFit()
        subTitleLable.frame.origin = CGPointMake(labelsOriginX, accumaltingHeight)
        self.addSubview(subTitleLable)
        
        accumaltingHeight += CGRectGetHeight(subTitleLable.bounds) + labelsMargin
        
        let distanceLabel = UILabel(frame: self.bounds)
        let km : Int = Int (anEvent.distanceFromUserLocation! / 1000)
        distanceLabel.text = anEvent.subtitle + " \(km) km from your location"
        distanceLabel.font = UIFont.systemFontOfSize(16)
        distanceLabel.textAlignment = NSTextAlignment.Left
        distanceLabel.numberOfLines = 0
        distanceLabel.sizeToFit()
        distanceLabel.frame.origin = CGPointMake(labelsOriginX, accumaltingHeight)
        self.addSubview(distanceLabel)
        
        accumaltingHeight += CGRectGetHeight(distanceLabel.bounds) + labelsMargin*2
        
        let navigateButton: UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        navigateButton.frame = CGRectMake(labelsOriginX, accumaltingHeight + labelsMargin, 55, 55)
        navigateButton.addTarget(self, action: "navigateButtonAction" , forControlEvents: UIControlEvents.TouchUpInside)
        navigateButton.setTitle("Nav", forState: .Normal)
        navigateButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        navigateButton.layer.cornerRadius = CGRectGetWidth(navigateButton.frame) / 2
        navigateButton.layer.borderWidth = 1
        navigateButton.layer.borderColor = UIColor.blueColor().CGColor
        navigateButton.tintColor = UIColor.blueColor()
        navigateButton.left(50)
        self.addSubview(navigateButton)
        
        let dissmissButton: UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        dissmissButton.frame = CGRectMake(labelsOriginX, accumaltingHeight + labelsMargin, 55, 55)
        dissmissButton.addTarget(self, action: "cancelButtonAction" , forControlEvents: UIControlEvents.TouchUpInside)
        dissmissButton.setTitle("Cancel", forState: .Normal)
        dissmissButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        dissmissButton.layer.cornerRadius = CGRectGetWidth(navigateButton.frame) / 2
        dissmissButton.layer.borderWidth = 1
        dissmissButton.layer.borderColor = UIColor.blueColor().CGColor
        dissmissButton.tintColor = UIColor.blueColor()
        dissmissButton.right(CGRectGetWidth(self.frame) - 50)
        self.addSubview(dissmissButton)
        
        let orderButton: UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        orderButton.frame = CGRectMake(labelsOriginX, accumaltingHeight + labelsMargin, 55, 55)
        orderButton.addTarget(self, action: "orderButtonAction" , forControlEvents: UIControlEvents.TouchUpInside)
        orderButton.setTitle("Order", forState: .Normal)
        orderButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        orderButton.layer.cornerRadius = CGRectGetWidth(navigateButton.frame) / 2
        orderButton.layer.borderWidth = 1
        orderButton.layer.borderColor = UIColor.blueColor().CGColor
        orderButton.tintColor = UIColor.blueColor()
        orderButton.center = CGPointMake(self.center.x, dissmissButton.center.y)
        self.addSubview(orderButton)

        
        accumaltingHeight += CGRectGetHeight(navigateButton.frame) + 20
        
        
        let size = CGSizeMake(CGRectGetWidth(self.bounds), accumaltingHeight)
        self.frame.size = size
    }
    
    func navigateButtonAction() {
      self.delegate?.eventDetailsViewdidRequestNavigationToEvent(self.event!)
    }
    
        
    func orderButtonAction(){
        println("order")
    }
    
    func cancelButtonAction(){
        if self.delegate != nil {
            self.delegate?.eventDetailsViewDidDissmiss()
        }
    }

    func prepareForReuse() {
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        self.accumaltingHeight = 5
    }
}
