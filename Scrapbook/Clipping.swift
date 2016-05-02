//
//  Clipping.swift
//  Scrapbook
//
//  Created by Chen Jonathan on 5/2/16.
//  Copyright © 2016 Chen Yi Tai. All rights reserved.
//

import Foundation
import CoreData


class Clipping: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    @NSManaged var image: String
    @NSManaged var notes: String
    @NSManaged var dateCreated: NSDate
    @NSManaged var collections: Collection?
}
