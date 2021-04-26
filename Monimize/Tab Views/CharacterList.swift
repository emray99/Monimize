//
//  CharacterList.swift
//  Movies
//
//  Created by Ray Liu on 4/10/21.
//

import SwiftUI

struct CharacterList: View {
    
    let movieName : String
    let namePile : [String]
        
    var body: some View {
       
            List {
                ForEach(namePile, id: \.self) { aName in
                    
                    CharacterItem(thisMovie: movieName, actorName: aName)
                }
            }   // End of List
        .customNavigationViewStyle()      // Given in NavigationStyle.swift

    }   // End of body
}

