//
//  MDPublishEventCVHeaderViewCollectionReusableView.swift
//  MapViewDemo
//
//  Created by Guy Freedman on 10/22/14.
//  Copyright (c) 2014 Guy Freeman. All rights reserved.
//

import UIKit

let initialCellHeight: CGFloat = 50

extension MDPublishEventMainTVC {
    

    func prepareInitialData () {
        for index in 0...7 {
            
            // Localized String
            let addString = NSLocalizedString("Add ", comment: "The prefix to add photo, add title etc.")
            let titile = addString + self.titleForHeaderAtIndexPath(index)
            
            //photo, description and publish button are not obligatory data
            if index == 0 || index == 2 || index == 7 {
                self.dataSource.append(cellData(initialTitle: titile, userData: "", height: initialCellHeight, containsUserData: false, isObligatory: false))
            }
            else {
                self.dataSource.append(cellData(initialTitle: titile, userData: "", height: initialCellHeight, containsUserData: false, isObligatory: true))
            }
        }
    }
    
    func titleForHeaderAtIndexPath (index: Int) -> String {
        
        var title = ""
        
        switch index {
        
        case 0:
            // Localized String
            title = NSLocalizedString("Photo", comment: "Add photo collection view header title")
        case 1:
            // Localized String
            title = NSLocalizedString("Title", comment: "Add Title collection view header")
        case 2:
            // Localized String
            title = NSLocalizedString("Description", comment: "Add Description collection view header")
        case 3:
            // Localized String
            title = NSLocalizedString("Address", comment: "Add address collection view header")
        case 4:
            // Localized String
            title = NSLocalizedString("Type Of Collection", comment:"The type of collecting collection view header")
        case 5:
            // Localized String
            title = NSLocalizedString("Starting Date", comment: "Collection view header")
        case 6:
            // Localized String
            title = NSLocalizedString("ending Date", comment: "Add Title collection view header")
        case 7:
            // Localized String
            title = NSLocalizedString("Publish", comment: "Publish the event to the server")
        default:
            title = ""
        }
        
        return title
    }
}