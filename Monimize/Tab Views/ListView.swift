//
//  ListView.swift
//  Monimize
//
//  Created by Eric Li on 4/27/21.
//

import SwiftUI

struct ListView: View {

    @EnvironmentObject var userData: UserData
    @State private var searchItem = ""
    var body: some View {
        NavigationView {
            List {
                SearchBar(searchItem: $searchItem, placeholder: "Search Expense Record")
                
                ForEach(userData.searchableOrderedBudgetsList.filter {self.searchItem.isEmpty ? true : $0.localizedStandardContains(self.searchItem)}, id: \.self)
                { item in
                    NavigationLink(destination: BudgetDetails(budget: self.searchItemBudget(searchListItem: item)))
                    {
                        BudgetItem(budget: self.searchItemBudget(searchListItem: item))
                    }
                }
                .onDelete(perform: delete)
               
            }   // End of List
            .navigationBarTitle(Text("My Expenses"), displayMode: .inline)
           
            // Place the Edit button on left and Add (+) button on right of the navigation bar
            .navigationBarItems(leading: EditButton(), trailing:
                NavigationLink(destination: AddBudget()) {
                    Image(systemName: "plus")
                })
           
        }   // End of NavigationView
            // Use single column navigation view for iPhone and iPad
            .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func searchItemBudget(searchListItem: String) -> BudgetStruct {
        /*
         searchListItem = "id|name|alpha2code|capital|languages|currency"
         country id = searchListItem.components(separatedBy: "|")[0]
         */
        // Find the index number of countriesList matching the country attribute 'id'
        let index = userData.budgetsList.firstIndex(where: {$0.id.uuidString == searchListItem.components(separatedBy: "|")[0]})!
       
        return userData.budgetsList[index]
    }
    
    func delete(at offsets: IndexSet) {
       
        if let index = offsets.first {
            let nameOfPhotoFileToDelete = userData.budgetsList[index].photoFilename
            let nameOfAudioFileToDelete = userData.budgetsList[index].audioFilename
            // Obtain the document directory file path of the file to be deleted
            let filePath = documentDirectory.appendingPathComponent(nameOfPhotoFileToDelete).path
            let urlOfAudioFileToDelete = documentDirectory.appendingPathComponent(nameOfAudioFileToDelete)
           
            do {
                let fileManager = FileManager.default
               
                // Check if the photo file exists in document directory
                if fileManager.fileExists(atPath: filePath) {
                    // Delete the photo file from document directory
                    try fileManager.removeItem(atPath: filePath)
                    try fileManager.removeItem(at: urlOfAudioFileToDelete)
                    

                } else {
                    // Photo file does not exist in document directory
                }
            } catch {
                print("Unable to delete the photo file from the document directory.")
            }
           
            // Remove the selected photo from the list
            userData.budgetsList.remove(at: index)
            userData.searchableOrderedBudgetsList.remove(at: index)
            // Set the global variable point to the changed list
            budgetStructList = userData.budgetsList
            orderedSearchableBudgetList = userData.searchableOrderedBudgetsList
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
