//
//  SvaingPlanList.swift
//  Monimize
//
//  Created by Guo Yang on 4/26/21.
//

import SwiftUI
import CoreData
 
struct SvaingPlanList: View {
   
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
   
    // ❎ CoreData FetchRequest returning all Song entities in the database
    @FetchRequest(fetchRequest: SavingItem.allSavingItemsFetchRequest()) var allSavingItems: FetchedResults<SavingItem>
   
    // ❎ Refresh this view upon notification that the managedObjectContext completed a save.
    // Upon refresh, @FetchRequest is re-executed fetching all Song entities with all the changes.
    @EnvironmentObject var userData: UserData
   
    var body: some View {
        NavigationView {
            List {
                /*
                 Each NSManagedObject has internally assigned unique ObjectIdentifier
                 used by ForEach to display the Songs in a dynamic scrollable list.
                 */
                ForEach(self.allSavingItems) { aSaving in
                    NavigationLink(destination: SavingDetails(saving: aSaving)) {
                        SavingListItem(saving: aSaving)
                    }
                }
                .onDelete(perform: delete)
               
            }   // End of List
            .navigationBarTitle(Text("My Saving Plans"), displayMode: .inline)
           
            // Place the Edit button on left and Add (+) button on right of the navigation bar
            .navigationBarItems(leading: EditButton(), trailing:
                NavigationLink(destination: AddSavingPlan()) {
                    Image(systemName: "plus")
                })
           
        }   // End of NavigationView
            // Use single column navigation view for iPhone and iPad
            .navigationViewStyle(StackNavigationViewStyle())
    }
   
    /*
     ----------------------------
     MARK: - Delete Selected Song
     ----------------------------
     */
    func delete(at offsets: IndexSet) {
       
        let tripToDelete = self.allSavingItems[offsets.first!]
       
        // ❎ CoreData Delete operation
        self.managedObjectContext.delete(tripToDelete)
 
        // ❎ CoreData Save operation
        do {
          try self.managedObjectContext.save()
        } catch {
          print("Unable to delete selected Plan!")
        }
    }
 
}
 
struct SongsList_Previews: PreviewProvider {
    static var previews: some View {
        SvaingPlanList()
    }
}

