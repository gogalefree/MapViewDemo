//
//  MDPublishEventTVCellTableViewCell.swift
//  MapViewDemo
//
//  Created by Guy Freedman on 10/23/14.
//  Copyright (c) 2014 Guy Freeman. All rights reserved.
//

import UIKit

class MDPublishEventTVCellTextField: PublishEventTVCellBase, UITextFieldDelegate, UITextViewDelegate {

    var textField: UITextField = UITextField(frame: CGRectMake(8, 10, 250, 30))

    var containsData: Bool = false
    
   override func setInitialState() {
    super.setInitialState()
    self.textField.delegate = self
    self.contentView.addSubview(self.textField)
    self.textField.keyboardType = UIKeyboardType.Default
    self.textField.keyboardAppearance = UIKeyboardAppearance.Default
    self.hideInputElement()
    }
    
    override func showInputElement() {
        self.layer.borderColor = UIColor.blueColor().CGColor
        self.layer.borderWidth = 1
        self.textField.alpha = 1
        self.textLabel.alpha = 0
        self.imageView.alpha = 0
        self.textField.becomeFirstResponder()
    }
    
    override func hideInputElement () {
        self.layer.borderColor = UIColor.clearColor().CGColor
        self.textField.alpha = 0
        self.textLabel.alpha = 1
        self.imageView.alpha = 1
        self.textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.textLabel.text = textField.text
        self.hideInputElement()
        if self.textLabel.text != "" {
            self.imageView.image = nil
            self.containsData = true
        }
        return true;
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
 //       self.textField.text = ""
 //       self.textLabel.text = ""
        self.hideInputElement()
    }
    
    class func heightForState (inputViewVisible: Bool) -> CGFloat {
    return 50
    }

}
