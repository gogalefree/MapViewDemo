//
//  MDUserDataInputVC.swift
//  MapViewDemo
//
//  Created by Guy Freedman on 10/24/14.
//  Copyright (c) 2014 Guy Freeman. All rights reserved.
//

import UIKit


protocol MDUserDataInputVCDelegate {
    func didEnterData(inputString: String,
        forState state:State)
    func didPickDate (date: NSDate)
    func didPickTypeOfCollecting (theTypeOfCollecting: TypeOfCollecting, withContactInfo infoString: String?)
}


enum State: Int {
    case TextField = 0 , TextView = 1, DatePickerStartingDate, DatePickerEndingDate, PickTypeOfCollecting
}

class MDUserDataInputVC: UIViewController,
    UITextFieldDelegate, UITextViewDelegate {
    
    let textFieldMaxLength = 40
    let textViewMaxLength = 200
    

    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    
    var inputString: String = ""
    var state: State = .TextField
    var delegate: MDUserDataInputVCDelegate!
    var userDidEnterContactInfo = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = ""
        // Localized String
        let title = NSLocalizedString("Done",comment: "done button title")
        
        let rightButton = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Done, target: self, action: "doneButtonAction")
        self.navigationItem.rightBarButtonItem = rightButton
        self.defineBordersToViews()
        
        self.textField.delegate = self
        self.textView.delegate = self
        self.setUpSegmentedController()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.state == .TextField {
            self.textField.alpha = 1
            self.textView.alpha = 0
            self.datePicker.alpha = 0
            self.segmentedControll.alpha = 0
            // Localized String
            titleLabel.text = NSLocalizedString("Event Title", comment: "the title of the event that will be published")
        }
        else if self.state == .TextView {
            self.textView.alpha = 1
            self.textField.alpha = 0
            self.datePicker.alpha = 0
            self.segmentedControll.alpha = 0
            // Localized String
            titleLabel.text = NSLocalizedString("Event Description", comment: "the description of the event that will be published")
        }
        
        else if self.state == .PickTypeOfCollecting {
            self.segmentedControll.alpha = 1
            self.textView.alpha = 0
            self.textField.alpha = 0
            self.datePicker.alpha = 0
            // Localized String
            titleLabel.text = NSLocalizedString("Pickup Method", comment: "the Pickup Method of the event that will be published")
        }
        else {
            self.datePicker.alpha = 1
            self.textField.alpha = 0
            self.textView.alpha = 0
            self.segmentedControll.alpha = 0
            if self.state == .DatePickerStartingDate{
                // Localized String
            self.titleLabel.text = NSLocalizedString("Event starting date", comment: "starting date title")
            }
            else{
                // Localized String
                 self.titleLabel.text = NSLocalizedString("Event endnig date", comment: "starting date title")
            }
        }
    }
    
   
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if self.state == State.TextField {
                self.textField.becomeFirstResponder()
                println("text field")
            }
            else if self.state != .PickTypeOfCollecting {
                self.textView.becomeFirstResponder()
                println("text view")

            }
        })
    }
    
    func doneButtonAction () {

        if self.state == .PickTypeOfCollecting {

            let theTypeOfCollecting = TypeOfCollecting(rawValue: self.segmentedControll.selectedSegmentIndex)

            if theTypeOfCollecting! == .FreePickup {
                
                self.delegate.didPickTypeOfCollecting(theTypeOfCollecting!, withContactInfo: nil)
            }
                
            else if !self.userDidEnterContactInfo {
                
                //contact publisher. user must supply phone number of e-mail
                return
            }
            
            else {
                self.inputString = self.textField.text
                if self.textField.text == "" {return}
                self.hideContactInfoUI()
                self.delegate.didPickTypeOfCollecting(theTypeOfCollecting!, withContactInfo: inputString)
                self.userDidEnterContactInfo = false
            }
        }
            
        else if ((self.state != .DatePickerStartingDate) &&
                (self.state != .DatePickerEndingDate)){
                    //save data
                    self.inputString = self.stringFromInputView()
        
                    //pass it to the delegate
                    self.delegate.didEnterData(self.inputString, forState: self.state)
        }
        else {
            self.delegate.didPickDate(self.datePicker.date)
        }
        
        //dissmiss
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func defineBordersToViews (){
        self.textView.layer.borderColor = UIColor.blueColor().CGColor
        self.textField.layer.borderColor = UIColor.blueColor().CGColor
        self.textView.layer.borderWidth = 0.5
        self.textField.layer.borderWidth = 0.5
        self.textView.layer.cornerRadius = 5
        self.textField.layer.cornerRadius = 5
    }

    func stringFromInputView() -> String {
        
        if self.state == .TextField {
            return self.textField.text
        }
        else if self.state == .TextView {
            return self.textView.text
        }
        return ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.doneButtonAction()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let count = countElements(textField.text) + countElements(string) - range.length
        return count < textFieldMaxLength
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let count = countElements(textView.text) + countElements(text) - range.length
        return count < textViewMaxLength
    }

    func presentContactInfoUI() {

        self.userDidEnterContactInfo = true
        self.textField.text = ""
        self.textField.placeholder = "Enter Email or Phone number"
        let origin: CGFloat = CGRectGetMaxY(self.segmentedControll.frame) + 25

        UIView.animateWithDuration(0.4, animations: { () -> Void in

            self.textField.bounds.size.width = 250
            self.textField.top(origin)
            self.textField.left(self.segmentedControll.frame.origin.x)
            self.textField.alpha = 1

            }) { (completion) -> Void in
                if completion {
                    self.textField.becomeFirstResponder()
                }
        }
    }
    
    func hideContactInfoUI() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.textField.alpha = 0
            self.textField.bounds.size.width = 300
            self.textField.top(CGRectGetMinY(self.textView.frame))
            self.textField.text = ""
            self.textField.placeholder = ""
            self.textField.left(10)
        })
    }
    
    func setUpSegmentedController() {
        
        // Localized String
        let freePickUpTitle = NSLocalizedString("Free Pickup", comment: "the title of a button. means that everyone can come to pick up the food without contacting the pubkisher")
        // Localized String
        let contactPublisher = NSLocalizedString("Contact Publisher", comment: "the title of a button. means that a collector must contact the publisher")
        self.segmentedControll.setTitle(freePickUpTitle, forSegmentAtIndex: 0)
        self.segmentedControll.setTitle(contactPublisher, forSegmentAtIndex: 1)
        self.segmentedControll.addTarget(self, action: "segmentedControllerTouched", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func segmentedControllerTouched() {
        
        if segmentedControll.selectedSegmentIndex == 1 {
            self.presentContactInfoUI()

        }
        else {
            self.hideContactInfoUI()
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.textField.resignFirstResponder()
        self.textView.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
