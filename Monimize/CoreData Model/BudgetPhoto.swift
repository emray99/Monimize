//
//  BudgetPhoto.swift
//  Monimize
//
//  Created by Eric Li on 4/27/21.
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
public class BudgetPhoto: NSManagedObject, Identifiable {
 
    @NSManaged public var photoData: Data?
    @NSManaged public var latitude: NSNumber?
    @NSManaged public var longitude: NSNumber?
    @NSManaged public var budget: Budget?
}
 
