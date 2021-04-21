//
//  Photo.swift
//  Monimize
//
//  Created by Ray Liu on 4/20/21.
//

import Foundation
import CoreData

 

/*
 🔴 Set Current Product Module:
    In xcdatamodeld editor, select Photo, show Data Model Inspector, and
    select Current Product Module from Module menu.
 🔴 Turn off Auto Code Generation:
    In xcdatamodeld editor, select Photo, show Data Model Inspector, and
    select Manual/None from Codegen menu.
*/

 

// ❎ CoreData Photo entity public class

public class Photo: NSManagedObject, Identifiable {

    @NSManaged public var latitude: NSNumber?
    @NSManaged public var longitude: NSNumber?
    @NSManaged public var itemPhoto: Data?
    @NSManaged public var item: Item?

}

 
