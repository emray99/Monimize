//
//  Home.swift
//  Monimize
//
//  Created by Eric Li on 4/27/21.
//

import SwiftUI
import SwiftUICharts



struct Home: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: SavingItem.allSavingItemsFetchRequest()) var allSavingItems: FetchedResults<SavingItem>
    

    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
            
        Form{
            if (userData.budgetsList.count == 0)
            {
                Section(header: Text("My Recent Expenses")) {
                    
                    Text("No expense items recorded")
                    
                   
                }
                
            }
            else
            {
                Section(header: Text("My Recent Expenses")) {
                    
                    List {
                        /*
                         Each NSManagedObject has internally assigned unique ObjectIdentifier
                         used by ForEach to display the Songs in a dynamic scrollable list.
                         */
                        let first3 = userData.budgetsList.prefix(3)
                        ForEach(first3) { aBudget in
                            NavigationLink(destination: BudgetDetails(budget: aBudget)) {
                                BudgetItem(budget: aBudget)
                            }
                        }
                        
                       
                    }   // End of List
                    
                   
                }
                
            }
            
            if (allSavingItems.count == 0)
            {
                
                Text("No saving plans.")
            }
            else
            {
                Section(header: Text("My Saving Plan recorded")) {
                    
                        List {
                            /*
                             Each NSManagedObject has internally assigned unique ObjectIdentifier
                             used by ForEach to display the Songs in a dynamic scrollable list.
                             */
                            let first3 = self.allSavingItems.prefix(3)
                            ForEach(first3) { aSaving in
                                NavigationLink(destination: SavingDetails(saving: aSaving)) {
                                    SavingListItem(saving: aSaving)
                                }
                            }
                            
                           
                        }   // End of List
                       
                        
                       
                    }   // End of NavigationView
                    .navigationViewStyle(StackNavigationViewStyle())
                
            }
        
        }
        }
  
    }
    
        
}
    

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
