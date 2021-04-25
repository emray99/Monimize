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
            TestItemList()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("ForTesting")
                }
           
     
        }   // End of TabView
            .font(.headline)
            .imageScale(.medium)
            .font(Font.title.weight(.regular))
    }
}
 
