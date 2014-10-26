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
            
            let addString = String.localizedStringWithFormat("Add ", "the prefix to add photo, add title etc.")
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
            title = String.localizedStringWithFormat("Photo", "add photo collection view header title")
        case 1:
            title = String.localizedStringWithFormat("Title", "add Title collection view header")
        case 2:
            title = String.localizedStringWithFormat("Description", "add Description collection view header")
        case 3:
            title = String.localizedStringWithFormat("Address", "add address collection view header")
        case 4:
            title = String.localizedStringWithFormat("Type Of Collection", "the type of collecting collection view header")
        case 5:
            title = String.localizedStringWithFormat("Starting Date", "collection view header")
        case 6:
            title = String.localizedStringWithFormat("ending Date", "add Title collection view header")
        case 7:
            title = String.localizedStringWithFormat("Publish", "publish the event to the server")
        default:
            title = ""
        }
        
        return title
    }
}