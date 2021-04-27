//
//  ContentView.swift
//  Monimize
//
//  Created by Ray Liu on 4/18/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Budgets()
                .tabItem {
                    Image(systemName: "dollarsign.circle")
                    Text("Budgets")
                }
            TestItemList()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("ForTesting")
                }
            
            SvaingPlanList()
                .tabItem {
                    Image(systemName: "magnifyingglass.circle")
                    Text("Svaing Plans")
                }
            
            MainSearchPage()
                .tabItem{
                    Image(systemName: "lasso.sparkles")
                    Text("Recreation")
                }
            
            GadgetMainPage()
                .tabItem{
                    Image(systemName: "wrench.and.screwdriver.fill")
                    Text("Gadgets")
                }
           
     
        }   // End of TabView
            .font(.headline)
            .imageScale(.medium)
            .font(Font.title.weight(.regular))
    }
}
 
