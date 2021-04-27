//
//  Budget.swift
//  Monimize
//
//  Created by Eric Li on 4/27/21.
//


import Foundation
import CoreData

/*
 🔴 Set Current Product Module:
 In xcdatamodeld editor, select Song, show Data Model Inspector, and
 select Current Product Module from Module menu.
 🔴 Turn off Auto Code Generation:
 In xcdatamodeld editor, select Song, show Data Model Inspector, and
 select Manual/None from Codegen menu.
 */

// ❎ CoreData Trip entity public class
public class Budget: NSManagedObject, Identifiable {
    
    @NSManaged public var title: String?
    @NSManaged public var currency: String?
    @NSManaged public var amount: NSNumber?
    @NSManaged public var note: String?
    @NSManaged public var audioFilename: String?
    @NSManaged public var date: String?
    @NSManaged public var photo: BudgetPhoto?
}

extension Budget {
    /*
     ❎ CoreData @FetchRequest in TripsList.swift invokes this Trip class method
     to fetch all of the Trip entities from the database.
     The 'static' keyword designates the func as a class method invoked by using the
     class name as Trip.allTripsFetchRequest() in any .swift file in your project.
     */
    static func allBudgetsFetchRequest() -> NSFetchRequest<Budget> {
        
        let request: NSFetchRequest<Budget> = Budget.fetchRequest() as! NSFetchRequest<Budget>
        /*
         List the Trip in alphabetical order with respect to rating;
         If rating is the same, then sort with respect to title.
         */
        request.sortDescriptors = [
            // Primary sort key: artistName
            NSSortDescriptor(key: "date", ascending: false),
            // Secondary sort key: songName
            NSSortDescriptor(key: "title", ascending: true)
        ]
        
        return request
    }
    
    /*
     ❎ CoreData @FetchRequest in SearchDatabase.swift invokes this Trip class method
     to fetch filtered Trip entities from the database for the given search query.
     The 'static' keyword designates the func as a class method invoked by using the
     class name as Trip.filteredTripsFetchRequest() in any .swift file in your project.
     */
    static func filteredBudgetsFetchRequest(searchCategory: String, searchQuery: String) -> NSFetchRequest<Budget> {
        
        let fetchRequest = NSFetchRequest<Budget>(entityName: "Budget")
        
        /*
         List the found Trips in alphabetical order with respect to rating;
         If rating is the same, then sort with respect to title.
         */
        fetchRequest.sortDescriptors = [
            // Primary sort key: artistName
            NSSortDescriptor(key: "date", ascending: false),
            // Secondary sort key: songName
            NSSortDescriptor(key: "title", ascending: true)
        ]
        
        // Case insensitive search [c] for searchQuery under each category
        switch searchCategory {
        case "Budget Title":
            fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@", searchQuery)
        case "Budget Amount":
            fetchRequest.predicate = NSPredicate(format: "amount <= %@", NSNumber(value: Double(searchQuery)!))
        case "Budget Currency":
            fetchRequest.predicate = NSPredicate(format: "currency CONTAINS[c] %@", searchQuery)
        case "Budget Date":
            fetchRequest.predicate = NSPredicate(format: "date CONTAINS[c] %@", searchQuery)
        case "Budget Note":
            fetchRequest.predicate = NSPredicate(format: "note CONTAINS[c] %@", searchQuery)
       
        default:
            print("Search category is out of range")
        }
        
        return fetchRequest
    }
}



