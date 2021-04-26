//
//  MovieList.swift
//  Monimize
//
//  Created by Ray Liu on 4/25/21.
//

import SwiftUI

struct NowPlayingList: View {
    
    var body: some View {
        //NavigationView {
            List {
                ForEach(recentMovieList) { aMovie in
                    
                    NavigationLink(destination: NowPlayingDetails(movie: aMovie)) {

                        NowPlayingItem(movie: aMovie)

                    }
                }
            }   // End of List
            .navigationBarTitle(Text("Movies Now Playing In Theathers"), displayMode: .inline)
       
        .customNavigationViewStyle()      // Given in NavigationStyle.swift
        }
    //}   // End of body
}

