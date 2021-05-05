//
//  Home.swift
//  Monimize
//
//  Created by Eric Li on 4/27/21.
//

import SwiftUI
import SwiftUICharts


extension Double {
    /// Rounds the double to decimal places value
    func roundedtoPlaces( places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
struct Home: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: SavingItem.allSavingItemsFetchRequest()) var allSavingItems: FetchedResults<SavingItem>
    

    @EnvironmentObject var userData: UserData
    //var totalSum = userData.budgetsList.map({$0.amount}).reduce(0, +)
    var body: some View {
        
        NavigationView {
            
        Form{
            Text("Total Expense: $\(String(format: "%.2f", totalSum))")
                .font(.title)
                .padding()
            PieChartView(
                data: [22, 17, 32, 99, 78, 64],
                title: "Pie Chart",
                legend: "Legendary"
            )
            
            
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
                    .navigationBarHidden(true)
                    .navigationViewStyle(StackNavigationViewStyle())
                
            }
        
        }
        }
  
    }
    var totalSum: Double {
        let list = userData.budgetsList
        return list.reduce(0, {$0 + $1.amount})
    }
    
        
}
    

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
