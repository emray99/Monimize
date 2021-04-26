//
//  SavingItem.swift
//  Monimize
//
//  Created by Guo Yang on 4/26/21.
//

import SwiftUI
import Foundation
import CoreData


 

// ❎ CoreData Song entity public class

public class SavingItem: NSManagedObject, Identifiable {

    @NSManaged public var expectDate: String?
    @NSManaged public var currentSave: NSNumber?
    @NSManaged public var budgetValue: NSNumber?
    @NSManaged public var budgetName: String?
    @NSManaged public var budgetDescription: String?
    @NSManaged public var savingPhoto: SavingItemPhoto?

}



 

extension SavingItem {

    /*
     ❎ CoreData @FetchRequest in SongsList.swift invokes this Song class method
        to fetch all of the Trip entities from the database.
        The 'static' keyword designates the func as a class method invoked by using the
        class name as Song.allSongsFetchRequest() in any .swift file in your project.
     */

    static func allSavingItemsFetchRequest() -> NSFetchRequest<SavingItem> {

        let request: NSFetchRequest<SavingItem> = SavingItem.fetchRequest() as! NSFetchRequest<SavingItem>

        /*
         List the songs in alphabetical order with respect to rating;
         If artistName is the same, then sort with respect to title.
         */

        request.sortDescriptors = [
            // Primary sort key: rating
            NSSortDescriptor(key: "budgetValue", ascending: false),

            // Secondary sort key: title
            NSSortDescriptor(key: "budgetName", ascending: true)
        ]

        return request

    }

   
    /*
     ❎ CoreData @FetchRequest in SearchDatabase.swift invokes this Song class method
        to fetch filtered Trip entities from the database for the given search query.
        The 'static' keyword designates the func as a class method invoked by using the
        class name as Song.filteredSongsFetchRequest() in any .swift file in your project.
     */

    static func filteredSavingItemsFetchRequest(searchCategory: String, searchQuery: String) -> NSFetchRequest<SavingItem> {

        let fetchRequest = NSFetchRequest<SavingItem>(entityName: "SavingItem")

        /*
         List the found songs in alphabetical order with respect to rating;
         If rating is the same, then sort with respect to title.
         */

        fetchRequest.sortDescriptors = [

            // Primary sort key: rating
            NSSortDescriptor(key: "budgetValue", ascending: true),

            // Secondary sort key: title
            NSSortDescriptor(key: "budgetName", ascending: true)

        ]

       

        // Case insensitive search [c] for searchQuery under each category

        switch searchCategory {
        
        case "Budget Name":

            fetchRequest.predicate = NSPredicate(format: "budgetName CONTAINS[c] %@", searchQuery)

        case "Budget Value":
            
            let search_cost = Double(searchQuery)

            fetchRequest.predicate = NSPredicate(format: "budgetValue <= %f", search_cost!)

      /*  case "Trip Notes":

            fetchRequest.predicate = NSPredicate(format: "notes CONTAINS[c] %@", searchQuery)

        case "Trip Start Date":
            
            fetchRequest.predicate = NSPredicate(format: "startDate CONTAINS[c] %@", searchQuery)

        case "Trip End Date":

            fetchRequest.predicate = NSPredicate(format: "endDate CONTAINS[c] %@", searchQuery)

        case "Trip Rating":
            
            let search_rating = Int(searchQuery)

            fetchRequest.predicate = NSPredicate(format: "rating == %i", search_rating!)

        case "Compound":

            let components = searchQuery.components(separatedBy: "AND")

            let yearQuery = components[0].trimmingCharacters(in: .whitespacesAndNewlines)

            let ratingQuery = components[1].trimmingCharacters(in: .whitespacesAndNewlines)

            let search_rating = Int(ratingQuery)
            

            fetchRequest.predicate = NSPredicate(format: "startDate CONTAINS[c] %@ AND rating == %i", yearQuery, search_rating!)*/

        default:

            print("Search category is out of range")

        }

        return fetchRequest

    }

}
