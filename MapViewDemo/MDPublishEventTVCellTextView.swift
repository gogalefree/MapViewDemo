//
//  MDPublishEventTVCellTextView.swift
//  MapViewDemo
//
//  Created by Guy Freedman on 10/23/14.
//  Copyright (c) 2014 Guy Freeman. All rights reserved.
//

import UIKit

class MDPublishEventTVCellTextView: PublishEventTVCellBase, UITextViewDelegate {
    
    var textView: UITextView = UITextView(frame: CGRectMake(8, 5, 304, 80))
    


    override func setInitialState() {
        super.setInitialState()
        self.textView.delegate = self
        self.textView.layer.borderColor = UIColor.blackColor().CGColor
        self.textView.layer.borderWidth = 0.5
        self.textView.layer.cornerRadius = 2
        self.contentView.addSubview(self.textView)
        self.hideInputElement()
    }
    
    override func showInputElement() {
        self.layer.borderColor = UIColor.blueColor().CGColor
        self.layer.borderWidth = 1
        self.textView.alpha = 1
        self.textLabel.alpha = 0
        self.imageView.alpha = 0
        self.textView.becomeFirstResponder()
    }
    
    override func hideInputElement () {
        self.layer.borderColor = UIColor.clearColor().CGColor
        self.textView.alpha = 0
        self.textLabel.alpha = 1
        self.imageView.alpha = 1
        self.textView.resignFirstResponder()
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        self.textLabel.text = textView.text
        self.hideInputElement()
        if self.textLabel.text != "" {
            self.imageView.image = nil
        }
        return true;
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.hideInputElement()
    }

    override func cellHeightWithData () -> CGFloat {
        return max(90, CGRectGetHeight(self.textLabel.bounds) + 5)
    }
    
    class func heightForState (inputViewVisible: Bool) -> CGFloat {
        if !inputViewVisible {
            return 50
        }
        return 90
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
