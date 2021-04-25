//
//  testItemList.swift
//  Monimize
//
//  Created by Ray Liu on 4/24/21.
//

import SwiftUI
import CoreData
 
struct TestItemList: View {
   
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
   
    // ❎ CoreData FetchRequest returning all Trip entities in the database
    @FetchRequest(fetchRequest: Item.allItemsFetchRequest()) var allItems: FetchedResults<Item>
   
    // ❎ Refresh this view upon notification that the managedObjectContext completed a save.
    // Upon refresh, @FetchRequest is re-executed fetching all Trip entities with all the changes.
    @EnvironmentObject var userData: UserData
   
    var body: some View {
        NavigationView {
            List {
                /*
                 Each NSManagedObject has internally assigned unique ObjectIdentifier
                 used by ForEach to display the Trips in a dynamic scrollable list.
                 */
                ForEach(self.allItems) { aItem in
                    NavigationLink(destination: TestItemDetails(item: aItem)) {
                        TestItemItem(item: aItem)
                    }
                }
                .onDelete(perform: delete)
               
            }   // End of List
            .navigationBarTitle(Text("My test items"), displayMode: .inline)
           
            // Place the Edit button on left and Add (+) button on right of the navigation bar
           
        }   // End of NavigationView
            // Use single column navigation view for iPhone and iPad
            .navigationViewStyle(StackNavigationViewStyle())
    }
   
    /*
     ----------------------------
     MARK: - Delete Selected Trip
     ----------------------------
     */
    func delete(at offsets: IndexSet) {
       
        let itemToDelete = self.allItems[offsets.first!]
       
        // ❎ CoreData Delete operation
        self.managedObjectContext.delete(itemToDelete)
 
        // ❎ CoreData Save operation
        do {
          try self.managedObjectContext.save()
        } catch {
          print("Unable to delete selected item!")
        }
    }
 
}
 
