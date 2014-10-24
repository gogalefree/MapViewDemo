//
//  MDPublishEventMainTVC.swift
//  MapViewDemo
//
//  Created by Guy Freedman on 10/23/14.
//  Copyright (c) 2014 Guy Freeman. All rights reserved.
//

import UIKit

struct cellData {
    var initialTitle: String
    var userData: AnyObject
    var height: CGFloat
}

class MDPublishEventMainTVC: UITableViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MDUserDataInputVCDelegate {
    
    
    var selectedIndexPath: NSIndexPath?
    var didEnterTitile = false , didEnterDescription = false
    var cellHeightWithData: CGFloat = 0
    var dataSource = [cellData]()
    var userDataInputVC: MDUserDataInputVC!
    var navController: UINavigationController!
    var readyToPublish = false

    override func viewDidLoad() {
       
        super.viewDidLoad()

        self.tableView.registerClass(PublishEventTVCellBase.self, forCellReuseIdentifier:
            NSStringFromClass(PublishEventTVCellBase.self))
        
        self.prepareInitialData()
        
        self.userDataInputVC = self.storyboard?.instantiateViewControllerWithIdentifier("MDUserDataInputVC") as MDUserDataInputVC
        self.userDataInputVC.delegate = self
        
        

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataSource.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellDataSource = self.dataSource[indexPath.section] as cellData
        return cellDataSource.height as CGFloat
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = self.tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(PublishEventTVCellBase)) as PublishEventTVCellBase
        cell.setInitialState()
        let data =  self.dataSource[indexPath.section] as cellData
        
        if data.userData as NSString == "" {
            cell.textLabel.text = data.initialTitle
        }
        else {
            cell.textLabel.text = data.userData as NSString
            cell.imageView.image = nil
        }
        
        if indexPath.section == self.dataSource.count-1 {
            cell.textLabel.text = String.localizedStringWithFormat("PUBLISH", "publish event button title")
            cell.imageView.image = nil
            cell.textLabel.textAlignment = .Center
            cell.textLabel.textColor = UIColor.grayColor()
            if !readyToPublish {
                cell.userInteractionEnabled = false
            }
        }
        return cell

    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.selectedIndexPath = indexPath
        self.presentUserDataInputVC()
    }
    
    func presentUserDataInputVC () {
   
        switch self.selectedIndexPath!.section {
        case 1:
            self.userDataInputVC.state = .TextField
            
        case 2:
            self.userDataInputVC.state = .TextView
            
        default:
            break
        }
        self.navController  = UINavigationController(rootViewController: self.userDataInputVC)
        self.presentViewController(navController, animated: true, nil)
    }
    
    
    //MDUserDataDelegate
    func didEnterData(inputString: String, forState state:State){
        
        //get the cell and text label
        let cell = self.tableView.cellForRowAtIndexPath(self.selectedIndexPath!) as PublishEventTVCellBase
        let label = cell.textLabel
        label.text = inputString
        
        //calculate new height
        label.sizeToFit()
        let newHeight = CGRectGetHeight(label.bounds) + 10
        
        //update data source
        var cellData = self.dataSource[self.selectedIndexPath!.section]
        cellData.height = max(initialCellHeight, newHeight) as CGFloat
        cellData.userData = inputString as String
        self.dataSource[self.selectedIndexPath!.section] = cellData
        
        //reload cell
        self.tableView.reloadRowsAtIndexPaths([self.selectedIndexPath!], withRowAnimation: .Automatic)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
