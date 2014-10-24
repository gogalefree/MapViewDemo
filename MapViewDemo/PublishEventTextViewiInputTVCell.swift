//
//  PublishEventTextViewiInputTVCell.swift
//  MapViewDemo
//
//  Created by Guy Freedman on 10/23/14.
//  Copyright (c) 2014 Guy Freeman. All rights reserved.
//

import UIKit

class PublishEventTextViewiInputTVCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.textView.delegate = self
        self.frame.size.height = 150
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
