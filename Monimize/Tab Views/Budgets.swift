//
//  Budgets.swift
//  Monimize
//
//  Created by Eric Li on 4/26/21.
//

import SwiftUI

struct Budgets: View {
   
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Budget.allBudgetsFetchRequest()) var allBudgets: FetchedResults<Budget>
    @EnvironmentObject var userData: UserData
    var body: some View {
        if allBudgets.count != 0 {
            return AnyView(ListView())
        } else {
            return AnyView(InitialView())
        }
       
    }
    
  
    
    
}

struct Budgets_Previews: PreviewProvider {
    static var previews: some View {
        Budgets()
    }
}
