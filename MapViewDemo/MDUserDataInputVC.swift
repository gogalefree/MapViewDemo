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
}

enum State: Int {
    case TextField = 0 , TextView = 1, DatePickerStartingDate, DatePickerEndingDate
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
    
    var inputString: String = ""
    var state: State = .TextField
    var delegate: MDUserDataInputVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = ""
        let title = String.localizedStringWithFormat("Done","done button title")
        
        let rightButton = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Done, target: self, action: "doneButtonAction")
        self.navigationItem.rightBarButtonItem = rightButton
        self.defineBordersToViews()
        
        self.textField.delegate = self
        self.textView.delegate = self

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.state == .TextField {
            self.textField.alpha = 1
            self.textView.alpha = 0
            self.datePicker.alpha = 0
            titleLabel.text = String.localizedStringWithFormat("Event Title", "the title of the event that will be published")
        }
        else if self.state == .TextView {
            self.textView.alpha = 1
            self.textField.alpha = 0
            self.datePicker.alpha = 0
            titleLabel.text = String.localizedStringWithFormat("Event Description", "the description of the event that will be published")
        }
        
        else {
            self.datePicker.alpha = 1
            self.textField.alpha = 0
            self.textView.alpha = 0
            if self.state == .DatePickerStartingDate{
            self.titleLabel.text = String.localizedStringWithFormat("Event starting date", "starting date title")
            }
            else{
                 self.titleLabel.text = String.localizedStringWithFormat("Event endnig date", "starting date title")
            }
        }
    }
    
   
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if self.state == State.TextField {
                self.textField.becomeFirstResponder()
            }
            else {
                self.textView.becomeFirstResponder()
            }
        })
    }
    
    func doneButtonAction () {
        if ((self.state != .DatePickerStartingDate) &&
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
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
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
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.textField.resignFirstResponder()
        self.textView.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
