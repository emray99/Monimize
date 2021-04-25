//
//  TestItemDetails.swift
//  Monimize
//
//  Created by Ray Liu on 4/24/21.
//

import SwiftUI
import Foundation
import MapKit

 
struct TestItemDetails: View {
   
    // ❎ Input parameter: CoreData Trip Entity instance reference
    let item: Item
   
    // ❎ CoreData FetchRequest returning all Trip entities in the database
    @FetchRequest(fetchRequest: Item.allItemsFetchRequest()) var allItems: FetchedResults<Item>
   
    // ❎ Refresh this view upon notification that the managedObjectContext completed a save.
    // Upon refresh, @FetchRequest is re-executed fetching all Trip entities with all the changes.
    @EnvironmentObject var userData: UserData
   
    var body: some View {
        Form {
            
            Section(header: Text("Item TITLE"))
            {
                Text(item.itemName!)
            }
            
            Section(header: Text("Item PHOTO"))
            {
                getImageFromBinaryData(binaryData: item.photo!.itemPhoto!, defaultFilename: "DefaultTripPhoto")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 300, maxWidth: 500, alignment: .center)
            }
            
            Section(header: Text("Item COST"))
            {
                Text(item.itemCost!.stringValue)
            }
            
         
         
 
        }   // End of Form
        .navigationBarTitle(Text("Trip Details"), displayMode: .inline)
        .font(.system(size: 14))
       
    }   // End of body
    
    
    
}
 
