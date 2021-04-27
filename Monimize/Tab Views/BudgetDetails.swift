//
//  BudgetDetails.swift
//  Monimize
//
//  Created by Eric Li on 4/27/21.
//

import SwiftUI

struct BudgetDetails: View {
    let budget: Budget
    @FetchRequest(fetchRequest: Budget.allBudgetsFetchRequest()) var allBudgets: FetchedResults<Budget>
    @EnvironmentObject var userData: UserData
    var body: some View {
        Form {
            Section(header: Text("Budget Title")) {
                Text(budget.title ?? "")
            }
            
            Section(header: Text("Budget Photo")) {
                // This public function is given in UtilityFunctions.swift
                getImageFromBinaryData(binaryData: budget.photo!.photoData!, defaultFilename: "DefaultTripPhoto")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 300, maxWidth: 500, alignment: .center)
            }
            
            Section(header: Text("Budget Amount")) {
                budgetAmount
            }
        } // End of Form
        .navigationBarTitle(Text("Budget Details"), displayMode: .inline)
        .font(.system(size: 14))
    }
    var budgetAmount: Text {
           let amount = budget.amount!.doubleValue
          
           // Add thousand separators to trip cost
           let numberFormatter = NumberFormatter()
           numberFormatter.numberStyle = .decimal
           numberFormatter.usesGroupingSeparator = true
           numberFormatter.groupingSize = 3
          
           let bAmount = "$" + numberFormatter.string(from: amount as NSNumber)!
           return Text(bAmount)
       }
}

