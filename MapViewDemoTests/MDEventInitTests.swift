//
//  MDEventInitTests.swift
//  MapViewDemoTests
//
//  Created by Guy Freedman on 10/14/14.
//  Copyright (c) 2014 Guy Freeman. All rights reserved.
//

import UIKit
import XCTest
import MapViewDemo
import CoreLocation

class MapViewDemoTests: XCTestCase {
    
    var event: MDEvent?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        event = MDEvent(annLocation:CLLocation(latitude: 32, longitude: 32) ,annTitle: "title", annSubtitle: "sun title")
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEventInitTitle() {
        // This is an example of a functional test case.
        XCTAssertNotNil (event?.title, "title was not set")
    }
    
    func testEventInitSubTitle() {
        // This is an example of a functional test case.
        XCTAssertNotNil (event?.subtitle, "subtitle was not set")
    }
    
    func testEventInitLocation() {
        // This is an example of a functional test case.
        let testCords = CLLocation(latitude: 32, longitude: 32)
        XCTAssertEqual (event!.coordinate.latitude, testCords.coordinate.latitude ,"coords was not set")
    }
    
    func testEventInitDistance() {
        // This is an example of a functional test case.
        XCTAssertNotNil (event!.distanceFromUserLocation, "distance was not set")
    }
 
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
