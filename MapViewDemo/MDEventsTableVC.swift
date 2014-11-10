//
//  MDEventsTableVC.swift
//  MapViewDemo
//
//  Created by Guy Freedman on 10/15/14.
//  Copyright (c) 2014 Guy Freeman. All rights reserved.
//

import UIKit

protocol EventsTableViewDelegate {
    func didSelectEvent (anEvent: MDEvent)
}
class MDEventsTableVC: UITableViewController {

    var events = [MDEvent]()
    var delegate: EventsTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        events = MDModel.sharedInstance.annotationsToPresent
        events = events.sorted({ (a1, a2) -> Bool in
            let one : MDEvent = a1
            let two : MDEvent = a2
            return one.distanceFromUserLocation < two.distanceFromUserLocation
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
  
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return events.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as UITableViewCell
        let event = self.events[indexPath.row] as MDEvent
        cell.textLabel.text = event.title
        let km : Int = Int (event.distanceFromUserLocation! / 1000)
        // Localized String
        cell.detailTextLabel?.text = event.subtitle + String(format: NSLocalizedString(" %d km from your location", comment: "Distance from current position to location point in kilometers."), km)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row <= events.count {
            self.navigationController?.popViewControllerAnimated(true)
            let event = events[indexPath.row]
            self.delegate?.didSelectEvent(event)
        }
    }
}
