//
//  SavingTabView.swift
//  Monimize
//
//  Created by Ray Liu on 5/3/21.
//

import SwiftUI

struct SavingTabView: View {
   
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: SavingItem.allSavingItemsFetchRequest()) var allSavingItems: FetchedResults<SavingItem>
    @EnvironmentObject var userData: UserData
    var body: some View {
        if self.allSavingItems.count != 0 {
            return AnyView(SvaingPlanList())
        } else {
            return AnyView(SavingInitialView())
        }
       
    }
}



