//
//  MainView.swift
//  Monimize
//
//  Created by Ray Liu on 5/3/21.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            Budgets()
                .tabItem {
                    Image(systemName: "dollarsign.circle")
                    Text("Expenses")
                }
            
            SavingTabView()
                .tabItem {
                    Image(systemName: "magnifyingglass.circle")
                    Text("Saving Plans")
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
