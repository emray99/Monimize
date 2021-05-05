//
//  ParkSearchResultsList.swift
//  Monimize
//
//  Created by Ray Liu on 4/25/21.
//

import SwiftUI

struct ParkSearchResutsList: View {
    
    var body: some View {
       
            List {
                ForEach(parkResultsList) { aPark in
                    NavigationLink(destination: ParkDetails(park: aPark)) {
                        ParkItem(park: aPark)

                    }
                }
            }   // End of List
            .navigationBarTitle(Text("Search Results"), displayMode: .inline)
       
        .customNavigationViewStyle()      // Given in NavigationStyle.swift

    }   // End of body
}


 

