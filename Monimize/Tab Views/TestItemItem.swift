//
//  TestItemItem.swift
//  Monimize
//
//  Created by Ray Liu on 4/24/21.
//

import SwiftUI
 
struct TestItemItem: View {
   
    // ❎ Input parameter: CoreData Trip Entity instance reference
    let item: Item
   
    // ❎ CoreData FetchRequest returning all Trip entities in the database
    @FetchRequest(fetchRequest: Item.allItemsFetchRequest()) var allItems: FetchedResults<Item>
   
    // ❎ Refresh this view upon notification that the managedObjectContext completed a save.
    // Upon refresh, @FetchRequest is re-executed fetching all Song entities with all the changes.
    @EnvironmentObject var userData: UserData
   
    var body: some View {
        HStack {
            // This public function is given in UtilityFunctions.swift
            getImageFromBinaryData(binaryData: item.photo!.itemPhoto!, defaultFilename: "DefaultTripPhoto")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120.0, height: 90.0)
           
            VStack(alignment: .leading) {
                /*
                ?? is called nil coalescing operator.
                IF song.artistName is not nil THEN
                    unwrap it and return its value
                ELSE return ""
                */
                Text(item.itemName!)
                Text(item.itemCost!.stringValue)
                
                
                Spacer()
               
            }
            .font(.system(size: 14))
        }
    }
}
 
 
struct stars: View {
    
    let starNum : Int
    
    var body: some View{
        
        HStack(spacing: 2){
           ForEach(0..<starNum) { _ in
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 13, height: 13)
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(.gray)
                        }
            Spacer()
            
        }
    
        
    }
}
