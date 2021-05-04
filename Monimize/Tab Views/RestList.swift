//
//  RestList.swift
//  Monimize
//
//  Created by Ray Liu on 5/4/21.
//

import SwiftUI

struct RestListPage: View {
    
    var body: some View {
        //NavigationView {
            List {
                ForEach(restResultsList) { aRest in
                    
                    NavigationLink(destination: RestDetails(rest: aRest)) {

                        RestItem(rest: aRest)

                    }
                }
            }   // End of List
            .navigationBarTitle(Text("Restaurants You Searched For!"), displayMode: .inline)
       
        .customNavigationViewStyle()      // Given in NavigationStyle.swift
                // }
    }   // End of body
}
