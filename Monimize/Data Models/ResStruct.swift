//
//  ResStruct.swift
//  Monimize
//
//  Created by Ray Liu on 5/4/21.
//

import SwiftUI


struct Rest: Hashable, Codable, Identifiable {
   
    public var id: UUID
    var rating: Double
    var price: String
    var phone: String
    var name: String
    var website: String
    var image: String
    var longitude: Double
    var latitude: Double
   
}
