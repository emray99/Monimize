//
//  SavingItem.swift
//  Monimize
//
//  Created by Guo Yang on 4/26/21.
//

import SwiftUI
 
struct SavingListItem: View {
   
    // ❎ Input parameter: CoreData Song Entity instance reference
    let saving: SavingItem
   
    // ❎ CoreData FetchRequest returning all Song entities in the database
    @FetchRequest(fetchRequest: SavingItem.allSavingItemsFetchRequest()) var allSavingItems: FetchedResults<SavingItem>
   
    // ❎ Refresh this view upon notification that the managedObjectContext completed a save.
    // Upon refresh, @FetchRequest is re-executed fetching all Song entities with all the changes.
    @EnvironmentObject var userData: UserData
    
    
    
    @State private var changeCheck = false
   
    var body: some View {
        HStack {
            // This public function is given in UtilityFunctions.swift
            getImageFromBinaryData(binaryData: saving.savingPhoto!.savingPhoto!, defaultFilename: "ImageUnavaliable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
            
            
            HStack{
                
                if (checkCompletion(saving: saving))
                {
                    Image(systemName:"checkmark.square")
                    .foregroundColor(Color.blue)
                    .imageScale(.large)
                    
                }
                else
                {
                    Image(systemName: "square")
                        .foregroundColor(Color.blue)
                        .imageScale(.large)
                }
           
                VStack(alignment: .leading) {
                    /*
                    ?? is called nil coalescing operator.
                    IF song.artistName is not nil THEN
                        unwrap it and return its value
                    ELSE return ""
                    */
                    
                    Text(saving.budgetName ?? "")
                    Text(saving.expectDate!)
                }
                .font(.system(size: 14))
                
                ProgressView("", value: getSavingPercent(saving: saving), total:100)
            }
        }
    }
    
    
}

public func checkCompletion(saving: SavingItem) -> Bool{
    let current = saving.currentSave!.doubleValue
    let target = saving.budgetValue!.doubleValue
    if (current >= target){
        return true
    }
    else {
        return false
    }
}


