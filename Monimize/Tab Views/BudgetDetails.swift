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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

