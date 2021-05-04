//
//  SavingDetails.swift
//  Monimize
//
//  Created by Guo Yang on 4/26/21.
//

import SwiftUI
import MapKit
 
struct SavingDetails: View {
   
    // ❎ Input parameter: CoreData Song Entity instance reference
    let saving: SavingItem
   
    // ❎ CoreData FetchRequest returning all Song entities in the database
    @FetchRequest(fetchRequest: SavingItem.allSavingItemsFetchRequest()) var allSavingItems: FetchedResults<SavingItem>
   
    // ❎ Refresh this view upon notification that the managedObjectContext completed a save.
    // Upon refresh, @FetchRequest is re-executed fetching all Song entities with all the changes.
    @EnvironmentObject var userData: UserData
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var savedAmountPercentage = 0.0
    @State var buttonPressed = false
    
    var body: some View {
        Form {

            /*
            ?? is called nil coalescing operator.
            IF song.albumName is not nil THEN
                unwrap it and return its value
            ELSE return ""
            */
            
            Section(header: Text("Add money to the budget plan")) {
                NavigationLink(destination: AddMoney(saving: saving)) {
                    HStack {
                        Image(systemName: "pencil.circle")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)
                        Text("Add Money")
                            .font(.system(size: 16))
                    }
                }
            }
            
            Section(header: Text("Svaing Plan Title")) {
                Text(saving.budgetName ?? "")
            }
            
            Section() {
                VStack{
                    if (!buttonPressed)
                    {
                        ProgressView("Saving Progress", value:getSavingPercent(saving: saving),total:100)
                                            .progressViewStyle(CirclerPercentProgressViewStyle())
                                            .frame(width: 120, height: 120,alignment: .center)
                                            .padding()
                    }
                    else
                    {
                        ProgressView("Saving Progress", value: self.savedAmountPercentage,total:100)
                                            .progressViewStyle(CirclerPercentProgressViewStyle())
                                            .frame(width: 120, height: 120,alignment: .center)
                                            .padding()
                        
                    }
                    
                    Button("Quick Add $50 saved for this item") {
                        self.buttonPressed.toggle()
                        getCurrentAmount(saving: saving)
                        
                        if (self.savedAmountPercentage <= 100)
                        {
                            changeStateSavedAmount(saving: saving)
                        }
                        
                        
                    }
                    
                }
                    
                
            }
            Section(header: Text("Target Budget")) {
                Text(addUSDSymbol(number: saving.budgetValue!))
            }
            
            Section(header: Text("Current Saving Money")) {
                //Text(saving.currentSave!.stringValue)
                Text(addUSDSymbol(number: saving.currentSave!))
            }
      
            Section(header: Text("Except budget Date")) {
                Text(saving.expectDate ?? "")
            }

            Section(header: Text("Budget description")) {
                Text(saving.budgetDescription ?? "")
            }
            
            
            
 
        }   // End of Form
        .navigationBarTitle(Text("Svaing Plan"), displayMode: .inline)
        .font(.system(size: 14))
       
    }   // End of body
    
    func getCurrentAmount(saving: SavingItem)
    {
        let current = Double(saving.currentSave!)
        let target = Double(saving.budgetValue!)
        let result = (current / target) * 100
        
        self.savedAmountPercentage = result
    }
    
    func changeStateSavedAmount(saving: SavingItem) {
        
        let current = Double(saving.currentSave!) + 50
        let target = Double(saving.budgetValue!)
        let result = (current / target) * 100
        
        self.savedAmountPercentage = result
        
        if (true)
        {
            let current = Double(saving.currentSave!)
            let result = current + 50
            saving.currentSave = NSNumber(value:result)
        }
        do {
            try self.managedObjectContext.save()
        } catch {
            return
        }
        
    }
    

    
}


public func getSavingPercent(saving: SavingItem) -> Double{
    
    let current = Double(saving.currentSave!)
    let target = Double(saving.budgetValue!)
    let result = (current / target) * 100
    return result
}

public func addUSDSymbol(number: NSNumber) -> String{
    var stringWithSymbol = number.stringValue
    stringWithSymbol.append(" $")
    
    return stringWithSymbol
    
}
 
