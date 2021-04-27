//
//  BudgetData.swift
//  Monimize
//
//  Created by Eric Li on 4/27/21.
//

import SwiftUI
import CoreData
 
// Array of TravelData structs for use only in this file
fileprivate var budgetDataStructList = [BudgetStruct]()
 
/*
 ***********************************
 MARK: - Create TravelData Database
 ***********************************
 */
public func createBudgetDatabase() {
 
    budgetDataStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "BudgetDataM.json", fileLocation: "Main Bundle")
   
    populateBudgetDatabase()
}
 
/*
*********************************************
MARK: - Populate Database If Not Already Done
*********************************************
*/
func populateBudgetDatabase() {
   
    // ❎ Get object reference of CoreData managedObjectContext from the persistent container
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    //----------------------------
    // ❎ Define the Fetch Request
    //----------------------------
    let fetchRequest = NSFetchRequest<Budget>(entityName: "Budget")
    fetchRequest.sortDescriptors = [
        // Primary sort key: artistName
        NSSortDescriptor(key: "date", ascending: false),
        // Secondary sort key: songName
        NSSortDescriptor(key: "title", ascending: true)
    ]
   
    var listOfAllBudgetEntitiesInDatabase = [Budget]()
   
    do {
        //-----------------------------
        // ❎ Execute the Fetch Request
        //-----------------------------
        listOfAllBudgetEntitiesInDatabase = try managedObjectContext.fetch(fetchRequest)
    } catch {
        print("Populate Database Failed!")
        return
    }
   
    if listOfAllBudgetEntitiesInDatabase.count > 0 {
        // Database has already been populated
        print("Budget Database has already been populated!")
        return
    }
   
    print("Database will be populated!")
   
    for data in budgetDataStructList {
        /*
         =====================================================
         Create an instance of the Record Entity and dress it up
         =====================================================
        */
       
        // ❎ Create an instance of the Record entity in CoreData managedObjectContext
        let budgetEntity = Budget(context: managedObjectContext)
       
        // ❎ Dress it up by specifying its attributes
        budgetEntity.title = data.title
        budgetEntity.amount = NSNumber(value: data.amount)
        budgetEntity.currency = data.currency
        budgetEntity.note = data.note
        budgetEntity.date = data.date

 
        /*
         ======================================================
         Create an instance of the Photo Entity and dress it up
         ======================================================
         */
       
        // ❎ Create an instance of the Photo Entity in CoreData managedObjectContext
        let photoEntity = BudgetPhoto(context: managedObjectContext)
       
        // Obtain the album cover photo image from Assets.xcassets as UIImage
        let photoUIImage = UIImage(named: data.photoFilename)
       
        // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
        let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
       
        // Assign photoData to Core Data entity attribute of type Data (Binary Data)
        photoEntity.budgetPhoto = photoData!
        photoEntity.latitude = NSNumber(value: data.photoLatitude)
        photoEntity.longitude = NSNumber(value: data.photoLongitude)

    

        /*
         ==============================
         Establish Entity Relationships
         ==============================
        */
       
        // ❎ Establish Relationship between entities Song and Photo
        budgetEntity.photo = photoEntity
        photoEntity.budget = budgetEntity
       
        /*
         ==================================
         Save Changes to Core Data Database
         ==================================
        */
       
        // ❎ CoreData Save operation
        do {
            try managedObjectContext.save()
        } catch {
            return
        }
       
    }   // End of for loop
 
}
 
