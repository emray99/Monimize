//
//  AddMoney.swift
//  Monimize
//
//  Created by Guo Yang on 4/26/21.
//

import SwiftUI
import CoreData

struct AddMoney: View {
    
    // ❎ Input parameter: Core Data Recipe Entity instance reference
    let saving: SavingItem
    
    // Enable this View to be dismissed to go back when the Save button is tapped
    @Environment(\.presentationMode) var presentationMode
    
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var showChangesAlert = false
    
    // Primary add money value
    @State private var addingMoney = 0.00
    
    // saving Item Entity Changes
    @State private var changeValue = false
    
    let costFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSize = 3
        return numberFormatter
        
    }()

    
    var body: some View {
        Form {
            Section(header: Text("Add Amount")) {
                recipeNameSubview
            }

        }   // End of Form
            .font(.system(size: 14))
            .alert(isPresented: $showChangesAlert, content: { self.changesAlert })
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .navigationBarTitle(Text("Add Money"), displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    if self.changesMade() {
                        self.saveChanges()
                    }
                    self.showChangesAlert = true
                }) {
                    Text("Add")
            })
    }   // End of body
    
    var recipeNameSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    currentValue
                    Button(action: {
                        self.changeValue.toggle()
                    }) {
                        Image(systemName: "pencil.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                }
                if self.changeValue {
                    HStack{
                        TextField("add money", value: $addingMoney, formatter: costFormatter)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                }
            }
        )
    }

    
    /*
     ---------------------
     MARK: - Alert Message
     ---------------------
     */
    var changesAlert: Alert {
        
        if changesMade() {
            return Alert(title: Text("Changes Saved!"),
                         message: Text("Your changes have been successfully saved to the database."),
                         dismissButton: .default(Text("OK")) {
                            self.presentationMode.wrappedValue.dismiss()
                })
        }
        
        return Alert(title: Text("No Changes Saved!"),
                     message: Text("You did not make any changes!"),
                     dismissButton: .default(Text("OK")) {
                        self.presentationMode.wrappedValue.dismiss()
            })
    }
    
    /*
     ---------------------------
     MARK: - Changes Made or Not
     ---------------------------
     */
    func changesMade() -> Bool {
        
        if self.addingMoney == 0.0 {
            return false
        }
        return true
    }
    
    /*
     ---------------------------
     MARK: - Save add money change
     ---------------------------
     */
    func saveChanges() {
        // add custom value of money into current saving
        
        if self.addingMoney != 0.0 {
            let current = Double(saving.currentSave!)
            let result = current + self.addingMoney
            saving.currentSave = NSNumber(value:result)
        }
        

        
        /*
         ==================================
         Save Changes to Core Data Database
         ==================================
         */
        
        // ❎ CoreData Save operation
        do {
            try self.managedObjectContext.save()
        } catch {
            return
        }
        
    }   // End of function
    
    var currentValue: Text {
          let costOfTrip = saving.currentSave!.doubleValue
        
          // Add thousand separators and symbols to current value
          let numberFormatter = NumberFormatter()
          numberFormatter.numberStyle = .decimal
          numberFormatter.usesGroupingSeparator = true
          numberFormatter.groupingSize = 3

          let tripCostString = "$" + numberFormatter.string(from: costOfTrip as NSNumber)!

          return Text(tripCostString)

      }
    
}

