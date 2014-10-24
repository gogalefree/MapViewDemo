//
//  PublishEventTVCellBase.swift
//  MapViewDemo
//
//  Created by Guy Freedman on 10/23/14.
//  Copyright (c) 2014 Guy Freeman. All rights reserved.
//

import UIKit

class PublishEventTVCellBase: UITableViewCell {
    
    func setInitialState () {
        self.imageView.image = UIImage(named: "add_user-32")
        self.textLabel.numberOfLines = 0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //must be implemented by subclasses
    func hideInputElement () { }
    
    //must be implemented by subclasses
    func showInputElement () { }

    func cellHeightWithData () -> CGFloat { return 50}
}
