//
//  MovieItem.swift
//  Monimize
//
//  Created by Ray Liu on 4/25/21.
//

import SwiftUI

struct NowPlayingItem: View {
   
    // Input Parameter
    let movie: Movie
   
    var body: some View {
        HStack {
            // Public function getImageFromUrl is given in UtilityFunctions.swift
            getImageFromUrl(url:  "https://image.tmdb.org/t/p/w500/\(movie.posterFileName)", defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
           
            VStack(alignment: .leading) {
                Text(movie.title)
                HStack{
                    Image("IMDb")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                    Text(movie.imdbRating)
                }
                Text(movie.actors)
                HStack{
                    Text(movie.mpaaRating)
                    Text("\(movie.runtime) mins")
                    Text(movie.releaseDate)
                }
            }
            .font(.system(size: 14))
           
        }   // End of HStack
    }
}
 


