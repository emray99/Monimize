//
//  MonimizeItemDataDataData.swift
//  Monimize
//
//  Created by Ray Liu on 4/20/21.
//

import SwiftUI

import CoreData
 
// Array of MusicAlbum structs for use only in this file
fileprivate var ExpenseStructList = [Expense]()
fileprivate var SavingStructList = [SavingStruct]()
 
/*
 ***********************************
 MARK: - Create Travel Database
 ***********************************
 */
public func createExpenseDatabase() {
 
    ExpenseStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "MonimizeItemData.json", fileLocation: "Main Bundle")
    SavingStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "SavingTest.json", fileLocation: "Main Bundle")
   
    populateDatabase()
    populateSavingDatabase()
}
 
/*
*********************************************
MARK: - Populate Database If Not Already Done
*********************************************
*/
func populateDatabase() {
   
    // ❎ Get object reference of CoreData managedObjectContext from the persistent container
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    //----------------------------
    // ❎ Define the Fetch Request
    //----------------------------
    let fetchRequest = NSFetchRequest<Item>(entityName: "Item")
    fetchRequest.sortDescriptors = [
        // Primary sort key: rating
        NSSortDescriptor(key: "itemCost", ascending: true),
        // Secondary sort key: title
        NSSortDescriptor(key: "itemName", ascending: true)
    ]
   
    var listOfAllItemEntitiesInDatabase = [Item]()
   
    do {
        //-----------------------------
        // ❎ Execute the Fetch Request
        //-----------------------------
        listOfAllItemEntitiesInDatabase = try managedObjectContext.fetch(fetchRequest)
    } catch {
        print("Populate Database Failed!")
        return
    }
   
    if listOfAllItemEntitiesInDatabase.count > 0 {
        // Database has already been populated
        print("Database has already been populated!")
        return
    }
   
    print("Database will be populated!")
   
    for expense in ExpenseStructList {
        /*
         =====================================================
         Create an instance of the Trip Entity and dress it up
         =====================================================
        */
       
        // ❎ Create an instance of the Trip entity in CoreData managedObjectContext
        let itemEntity = Item(context: managedObjectContext)
       
        // ❎ Dress it up by specifying its attributes
        itemEntity.itemCost = NSNumber(value: expense.itemCost)
        itemEntity.itemDescription = expense.itemDescription
        itemEntity.itemLocation = expense.itemLocation
        itemEntity.itemName = expense.itemName
        itemEntity.purchaseTime = expense.purchaseTime
        itemEntity.trailerID = expense.trailerID
        
 
        /*
         ======================================================
         Create an instance of the Photo Entity and dress it up
         ======================================================
         */
       
        // ❎ Create an instance of the Photo Entity in CoreData managedObjectContext
        let photoEntity = Photo(context: managedObjectContext)
       
        // Obtain the album cover photo image from Assets.xcassets as UIImage
        let photoUIImage = UIImage(named: expense.photoFilename)
       
        // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
        let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
       
        // Assign photoData to Core Data entity attribute of type Data (Binary Data)
        photoEntity.itemPhoto = photoData!
        
    
        photoEntity.latitude = NSNumber(value: expense.photoLatitude)
        photoEntity.longitude = NSNumber(value: expense.photoLongitude)
        
        /*
         ==============================
         Establish Entity Relationships
         ==============================
        */
       
        // ❎ Establish Relationship between entities Trip and Photo
        itemEntity.photo = photoEntity
        photoEntity.item = itemEntity
       
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
 

func populateSavingDatabase() {
   
    // ❎ Get object reference of CoreData managedObjectContext from the persistent container
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    //----------------------------
    // ❎ Define the Fetch Request
    //----------------------------
    let fetchRequest = NSFetchRequest<SavingItem>(entityName: "SavingItem")
    fetchRequest.sortDescriptors = [
        // Primary sort key: rating
        NSSortDescriptor(key: "budgetValue", ascending: true),
        // Secondary sort key: title
        NSSortDescriptor(key: "budgetName", ascending: true)
    ]
   
    var listOfAllSavingItemEntitiesInDatabase = [SavingItem]()
   
    do {
        //-----------------------------
        // ❎ Execute the Fetch Request
        //-----------------------------
        listOfAllSavingItemEntitiesInDatabase = try managedObjectContext.fetch(fetchRequest)
    } catch {
        print("Populate Database Failed!")
        return
    }
   
    if listOfAllSavingItemEntitiesInDatabase.count > 0 {
        // Database has already been populated
        print("Database has already been populated!")
        return
    }
   
    print("Database will be populated!")
   
    for savingItem in SavingStructList {
        /*
         =====================================================
         Create an instance of the Trip Entity and dress it up
         =====================================================
        */
       
        // ❎ Create an instance of the Trip entity in CoreData managedObjectContext
        let savingItemEntity = SavingItem(context: managedObjectContext)
       
        // ❎ Dress it up by specifying its attributes
        savingItemEntity.budgetValue = NSNumber(value: savingItem.budgetValue)
        savingItemEntity.currentSave = NSNumber(value: savingItem.currentSave)
        savingItemEntity.budgetDescription = savingItem.budgetDescription
        savingItemEntity.budgetName = savingItem.budgetName
        savingItemEntity.expectDate = savingItem.expectDate

        
 
        /*
         ======================================================
         Create an instance of the Photo Entity and dress it up
         ======================================================
         */
       
        // ❎ Create an instance of the Photo Entity in CoreData managedObjectContext
        let photoEntity = SavingItemPhoto(context: managedObjectContext)
       
        // Obtain the album cover photo image from Assets.xcassets as UIImage
        let photoUIImage = UIImage(named: savingItem.photoFilename)
       
        // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
        let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
       
        // Assign photoData to Core Data entity attribute of type Data (Binary Data)
        photoEntity.savingPhoto = photoData!
        
    
        photoEntity.savingLatitude = NSNumber(value: savingItem.photoLatitude)
        photoEntity.savingLongitude = NSNumber(value: savingItem.photoLongitude)
        
        /*
         ==============================
         Establish Entity Relationships
         ==============================
        */
       
        // ❎ Establish Relationship between entities Trip and Photo
        savingItemEntity.savingPhoto = photoEntity
        photoEntity.savingItem = savingItemEntity
       
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

