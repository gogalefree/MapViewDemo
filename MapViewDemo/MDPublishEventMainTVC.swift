//
//  MDPublishEventMainTVC.swift
//  MapViewDemo
//
//  Created by Guy Freedman on 10/23/14.
//  Copyright (c) 2014 Guy Freeman. All rights reserved.
//

import UIKit

let newEventPublishedNotification = "newEventPublished"

struct cellData {
    var initialTitle: String
    var userData: AnyObject
    var height: CGFloat
    var containsUserData: Bool
    var isObligatory : Bool
}

class MDPublishEventMainTVC: UITableViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, MDUserDataInputVCDelegate {
    
    let imageViewHeight: CGFloat = 150
    let imageViewWidth: CGFloat = 200
    
    var selectedIndexPath: NSIndexPath?
    var didEnterTitile = false , didEnterDescription = false
    var cellHeightWithData: CGFloat = 0
    var dataSource = [cellData]()
    var userDataInputVC: MDUserDataInputVC!
    var navController: UINavigationController!
    var readyToPublish = false
    lazy var imagePicker: UIImagePickerController = UIImagePickerController()


    override func viewDidLoad() {
       
        super.viewDidLoad()

        self.tableView.registerClass(PublishEventTVCellBase.self, forCellReuseIdentifier:
            NSStringFromClass(PublishEventTVCellBase.self))
        
        self.prepareInitialData()
        
        self.userDataInputVC = self.storyboard?.instantiateViewControllerWithIdentifier("MDUserDataInputVC") as MDUserDataInputVC
        self.userDataInputVC.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.checkReadyToSubmmit()
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
        
        var cell = self.tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(PublishEventTVCellBase))
            as PublishEventTVCellBase
        
        let theCellData =  self.dataSource[indexPath.section] as cellData
        
        if !theCellData.containsUserData {
            cell.setInitialState()
            cell.textLabel.text = theCellData.initialTitle
        }
        
        else{
        
            if theCellData.userData is UIImage {
                let imageView = UIImageView(image: (theCellData.userData) as UIImage)
                imageView.frame.size = CGSizeMake(self.imageViewWidth, self.imageViewHeight)
                imageView.center = cell.contentView.center
                cell.contentView.addSubview(imageView)
                cell.imageView.image = nil
                cell.textLabel.text = ""
            }
        
            else {
                cell.textLabel.text = theCellData.userData as NSString
                cell.imageView.image = nil
            }
        }
        
        if indexPath.section == self.dataSource.count-1 {
            
            // Localized String
            cell.textLabel.text = NSLocalizedString("PUBLISH", comment: "Publish event button title")
            cell.imageView.image = nil
            cell.textLabel.textAlignment = .Center
            cell.textLabel.textColor = UIColor.grayColor()
            if !readyToPublish {
                cell.userInteractionEnabled = false
            }
            else {
                cell.backgroundColor = UIColor.greenColor()
                cell.textLabel.textColor = UIColor.blueColor()
            }
        }
        
        return cell

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if indexPath.section == self.dataSource.count-1 &&
            self.readyToPublish {

                //publish the event
                var title = self.dataSource[1].userData as String
                var subtitle = self.dataSource[2].userData as String
                var currentLocation = MDModel.sharedInstance.userLocation
                var newEvent = MDEvent(annLocation: currentLocation, annTitle: title, annSubtitle: subtitle)
                MDModel.sharedInstance.annotationsToPresent.append(newEvent)
            
                var publishMainVC = self.navigationController?.viewControllers.first as PublishMainVC
                publishMainVC.needsUpdate = true
                publishMainVC.newEventPublished = newEvent
                self.navigationController?.popToRootViewControllerAnimated(true)
               // NSNotificationCenter.defaultCenter().postNotificationName(newEventPublishedNotification, object: newEvent)
                //cleanup

            return
        }

        self.selectedIndexPath = indexPath
        self.presentUserDataInputVC()
    }
    
    func presentUserDataInputVC () {
   
        switch self.selectedIndexPath!.section {
        case 0:
            self.presentImagePickerController()
        case 1:
            self.userDataInputVC.state = .TextField
        case 2...3:
            self.userDataInputVC.state = .TextView
        case 4:
            self.userDataInputVC.state = .PickTypeOfCollecting
        case 5:
            self.userDataInputVC.state = .DatePickerStartingDate
        case 6:
            self.userDataInputVC.state = .DatePickerEndingDate
           
        default:
            break
        }
    
        if self.selectedIndexPath!.section != 0 {
        self.navController  = UINavigationController(rootViewController: self.userDataInputVC)
        self.presentViewController(navController, animated: true, nil)
        }
    }
    
    
    //MDUserDataInputVCDelegate
    func didEnterData(inputString: String, forState state:State){
        self.updateCellData(inputString)
    }
    
    func didPickTypeOfCollecting (theTypeOfCollecting: TypeOfCollecting, withContactInfo infoString: String?) {
        
        var inputString = infoString ?? ""
        
        if theTypeOfCollecting == .FreePickup {
            inputString = "Free Pickup"
        }
        else if theTypeOfCollecting == .ContactPublisher{
            inputString = "Contact:\n" + inputString
        }

        self.updateCellData(inputString)
    }

    func didPickDate(date: NSDate) {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let dateString = formatter.stringFromDate(date)
        self.updateCellData(dateString)
    }
    
    func updateCellData (inputString: String) {
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
        cellData.containsUserData = true
        self.dataSource[self.selectedIndexPath!.section] = cellData
        
        //reload cell
        self.tableView.reloadRowsAtIndexPaths([self.selectedIndexPath!], withRowAnimation: .Automatic)
    }
    
    func checkReadyToSubmmit() {

        var ready = true
        for cellData in self.dataSource {
         
            if cellData.isObligatory{
                if !cellData.containsUserData {ready = false}
            }
        }
        
        if ready {
            let indexPathOfPublishCell = NSIndexPath(forRow: 0, inSection: self.dataSource.count-1)
            self.readyToPublish = ready
            self.tableView.reloadRowsAtIndexPaths([indexPathOfPublishCell], withRowAnimation: .Automatic)
            self.tableView.scrollToRowAtIndexPath(indexPathOfPublishCell, atScrollPosition: UITableViewScrollPosition.Bottom,
                animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MDPublishEventMainTVC {
    
    func presentImagePickerController () {
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)

        var myInfo = info
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image = info[UIImagePickerControllerOriginalImage] as UIImage
            self.updateCellDataWithImage(image)
        }

    }
    
    func updateCellDataWithImage(anImage: UIImage) {
        
        let cell = self.tableView.cellForRowAtIndexPath(self.selectedIndexPath!) as PublishEventTVCellBase
        
        //update data source
        var cellData = self.dataSource[self.selectedIndexPath!.section]
        cellData.height = max(initialCellHeight, self.imageViewHeight) as CGFloat
        cellData.userData = anImage as UIImage
        cellData.containsUserData = true
        self.dataSource[self.selectedIndexPath!.section] = cellData
        
        //reload cell
        self.tableView.reloadRowsAtIndexPaths([self.selectedIndexPath!], withRowAnimation: .Automatic)
        
    }
}
/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
if ([info objectForKey:UIImagePickerControllerEditedImage]){
UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];

if (image) {
self.eventImageView.image = [UIImage imageWithImage:image scaledToSize:CGSizeMake(280, 180) cornerRadius:10.0f];//image;
self.addPhotoButton.alpha=0;
UIButton *addButon = [UIButton buttonWithType:UIButtonTypeSystem];
[addButon addTarget:self action:@selector(addPhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
addButon.frame = self.eventImageView.frame;
[self.view addSubview:addButon];
}
}


[self.navigationController dismissViewControllerAnimated:YES completion:nil];


//    NSString *const UIImagePickerControllerMediaType;
//    NSString *const UIImagePickerControllerOriginalImage;
//    NSString *const UIImagePickerControllerEditedImage;
//    NSString *const UIImagePickerControllerCropRect;
//    NSString *const UIImagePickerControllerMediaURL;
//    NSString *const UIImagePickerControllerReferenceURL;
//    NSString *const UIImagePickerControllerMediaMetadata;
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
if (!self.eventImageView.image){
self.addPhotoButton.alpha=1;
NSLog(@"picker did cacel");
}

[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
*/