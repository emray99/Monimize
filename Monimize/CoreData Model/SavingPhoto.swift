//
//  SavingPhoto.swift
//  Monimize
//
//  Created by Guo Yang on 4/26/21.
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

public class SavingItemPhoto: NSManagedObject, Identifiable {

    @NSManaged public var savingLatitude: NSNumber?
    @NSManaged public var savingLongitude: NSNumber?
    @NSManaged public var savingPhoto: Data?
    @NSManaged public var savingItem: SavingItem?

}
