//
//  UIViewExtensions.swift
//  MapViewDemo
//
//  Created by Guy Freedman on 10/16/14.
//  Copyright (c) 2014 Guy Freeman. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    public func top (allignTop: CGFloat) {
        let newOrigin = CGPointMake(CGRectGetMinX(self.frame), allignTop)
        self.frame.origin = newOrigin
    }
    
    public func buttom (allignButtom: CGFloat) {
        let deltaY = allignButtom - CGRectGetMaxY(self.frame)
        let newOrigin = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame)+deltaY)
        self.frame.origin = newOrigin
    }
    
    public func left (allignLeft: CGFloat) {
        let newOrigin = CGPointMake(allignLeft, CGRectGetMinY(self.frame))
        self.frame.origin = newOrigin
    }
    
    public func right (allignRight: CGFloat) {
        let deltaX = allignRight - CGRectGetMaxX(self.frame)
        let newOrigin = CGPointMake(CGRectGetMinX(self.frame) + deltaX, CGRectGetMinY(self.frame))
        self.frame.origin = newOrigin
    }
}