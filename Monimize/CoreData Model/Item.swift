//
//  Item.swift
//  Monimize
//
//  Created by Ray Liu on 4/20/21.
//

import SwiftUI

import Foundation

import CoreData


 

// ❎ CoreData Song entity public class

public class Item: NSManagedObject, Identifiable {

    @NSManaged public var itemCost: NSNumber?
    @NSManaged public var itemName: String?
    @NSManaged public var itemLocation: String?
    @NSManaged public var itemDescription: String?
    @NSManaged public var purchaseTime: String?
    @NSManaged public var trailerID: String?
    @NSManaged public var photo: Photo?

}

 

extension Item {

    /*
     ❎ CoreData @FetchRequest in SongsList.swift invokes this Song class method
        to fetch all of the Trip entities from the database.
        The 'static' keyword designates the func as a class method invoked by using the
        class name as Song.allSongsFetchRequest() in any .swift file in your project.
     */

    static func allItemsFetchRequest() -> NSFetchRequest<Item> {

        let request: NSFetchRequest<Item> = Item.fetchRequest() as! NSFetchRequest<Item>

        /*
         List the songs in alphabetical order with respect to rating;
         If artistName is the same, then sort with respect to title.
         */

        request.sortDescriptors = [
            // Primary sort key: rating
            NSSortDescriptor(key: "itemCost", ascending: false),

            // Secondary sort key: title
            NSSortDescriptor(key: "itemName", ascending: true)
        ]

        return request

    }

   
    /*
     ❎ CoreData @FetchRequest in SearchDatabase.swift invokes this Song class method
        to fetch filtered Trip entities from the database for the given search query.
        The 'static' keyword designates the func as a class method invoked by using the
        class name as Song.filteredSongsFetchRequest() in any .swift file in your project.
     */

    static func filteredItemsFetchRequest(searchCategory: String, searchQuery: String) -> NSFetchRequest<Item> {

        let fetchRequest = NSFetchRequest<Item>(entityName: "Item")

        /*
         List the found songs in alphabetical order with respect to rating;
         If rating is the same, then sort with respect to title.
         */

        fetchRequest.sortDescriptors = [

            // Primary sort key: rating
            NSSortDescriptor(key: "itemCost", ascending: true),

            // Secondary sort key: title
            NSSortDescriptor(key: "itemName", ascending: true)

        ]

       

        // Case insensitive search [c] for searchQuery under each category

        switch searchCategory {
        
        case "Item Name":

            fetchRequest.predicate = NSPredicate(format: "itemName CONTAINS[c] %@", searchQuery)

        case "Item Cost":
            
            let search_cost = Double(searchQuery)

            fetchRequest.predicate = NSPredicate(format: "itemCost <= %f", search_cost!)

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

 

