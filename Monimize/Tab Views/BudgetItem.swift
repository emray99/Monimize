//
//  BudgetItem.swift
//  Monimize
//
//  Created by Eric Li on 4/27/21.
//

import SwiftUI

struct BudgetItem: View {
    let budget: Budget
    @FetchRequest(fetchRequest: Budget.allBudgetsFetchRequest()) var allBudgets: FetchedResults<Budget>
    @EnvironmentObject var userData: UserData
    var body: some View {
        HStack {
            // This public function is given in UtilityFunctions.swift
            Image("\(budget.category)")
            
            VStack(alignment: .leading) {
                /*
                ?? is called nil coalescing operator.
                IF song.artistName is not nil THEN
                    unwrap it and return its value
                ELSE return ""
                */
                Text(budget.title ?? "")

                
                budgetAmount

                Text(budget.currency ?? "")

            }
            .font(.system(size: 14))
        }
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


