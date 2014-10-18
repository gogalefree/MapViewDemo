//
//  PublishMainVC.swift
//  MapViewDemo
//
//  Created by Guy Freedman on 10/18/14.
//  Copyright (c) 2014 Guy Freeman. All rights reserved.
//

import UIKit

class PublishMainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource = [MDAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Shares"
        dataSource = MDModel.sharedInstance.annotationsToPresent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
     
        let reusableId = "userEventsCollectionViewCell"
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(reusableId, forIndexPath: indexPath) as UICollectionViewCell
        var titleLabel = UILabel(frame: CGRectMake(48, 5, 180, 50))
        titleLabel.text = self.dataSource[indexPath.item].title
        titleLabel.font = UIFont.systemFontOfSize(18)
        titleLabel.textAlignment  = NSTextAlignment.Center
        cell.contentView.addSubview(titleLabel)
        
        var onAirLabel = UILabel(frame: CGRectMake(48, 55, 180, 33))
        onAirLabel.text = "On Air"
        onAirLabel.font = UIFont.systemFontOfSize(14)
        onAirLabel.textAlignment  = NSTextAlignment.Center
        onAirLabel.textColor = UIColor.greenColor()
        if indexPath.item > 1 {
            onAirLabel.text = "Expired"
            onAirLabel.textColor = UIColor.redColor()
        }
        cell.contentView.addSubview(onAirLabel)
        
        cell.contentView.layer.borderColor = UIColor.blueColor().CGColor
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.cornerRadius = 5
        cell.contentView
        return cell
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
            return 1
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
