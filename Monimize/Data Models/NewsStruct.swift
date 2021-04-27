//
//  NewsStruct.swift
//  Monimize
//
//  Created by Ray Liu on 4/26/21.
//

import SwiftUI

struct News: Hashable, Codable, Identifiable {
   
    public var id: UUID
    var title: String
    var author: String
    var language: String
    var time: String
    var website: String
    var description: String
    var category: String
    var image: String
   
}
