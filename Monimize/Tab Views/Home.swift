//
//  Home.swift
//  Monimize
//
//  Created by Eric Li on 4/27/21.
//

import SwiftUI



struct Home: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: SavingItem.allSavingItemsFetchRequest()) var allSavingItems: FetchedResults<SavingItem>
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
        Form{
            Section(header: Text("Svaing Plan Title")) {
                Image("pie-chart")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                    //.padding()
            }
        
        Section(header: Text("My Saving Plans")) {
            
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

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
