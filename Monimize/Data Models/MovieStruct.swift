//
//  MovieStruct.swift
//  Monimize
//
//  Created by Ray Liu on 4/25/21.
//

import SwiftUI

struct Movie: Hashable, Codable, Identifiable {
   
    public var id: UUID
    var title: String
    var posterFileName: String
    var overview: String
    var genres: String
    var releaseDate: String
    var runtime: Int
    var director: String
    var actors: String
    var mpaaRating: String
    var imdbRating: String
    var youTubeTrailerId: String
    var tmdbID: Int
   
}
