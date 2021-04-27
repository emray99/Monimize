//
//  ListView.swift
//  Monimize
//
//  Created by Eric Li on 4/27/21.
//

import SwiftUI

struct ListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Budget.allBudgetsFetchRequest()) var allBudgets: FetchedResults<Budget>
    @EnvironmentObject var userData: UserData
    var body: some View {
        NavigationView {
            List {
                /*
                 Each NSManagedObject has internally assigned unique ObjectIdentifier
                 used by ForEach to display the Songs in a dynamic scrollable list.
                 */
                ForEach(self.allBudgets) { aBudget in
                    NavigationLink(destination: BudgetDetails(budget: aBudget)) {
                        BudgetItem(budget: aBudget)
                    }
                }
                .onDelete(perform: delete)
               
            }   // End of List
            .navigationBarTitle(Text("My Budgets"), displayMode: .inline)
           
            // Place the Edit button on left and Add (+) button on right of the navigation bar
            .navigationBarItems(leading: EditButton(), trailing:
                NavigationLink(destination: AddBudget()) {
                    Image(systemName: "plus")
                })
           
        }   // End of NavigationView
            // Use single column navigation view for iPhone and iPad
            .navigationViewStyle(StackNavigationViewStyle())
    }
    func delete(at offsets: IndexSet) {
       
        let budgetToDelete = self.allBudgets[offsets.first!]
       
        // ❎ CoreData Delete operation
        self.managedObjectContext.delete(budgetToDelete)
 
        // ❎ CoreData Save operation
        do {
          try self.managedObjectContext.save()
        } catch {
          print("Unable to delete selected Budget!")
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
