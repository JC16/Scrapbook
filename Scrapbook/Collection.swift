//
//  Collection.swift
//  Scrapbook
//
//  Created by Chen Jonathan on 5/2/16.
//  Copyright © 2016 Chen Yi Tai. All rights reserved.
//

import Foundation
import CoreData


class Collection: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    @NSManaged var name: String
    @NSManaged var clippings: NSSet
    
    func addCliping (clipping: Clipping)
    {
        self.mutableSetValueForKey("myClippings").addObject(Clipping)
    }

}
