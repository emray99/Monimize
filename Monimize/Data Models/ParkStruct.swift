//
//  ParkStruct.swift
//  Monimize
//
//  Created by Ray Liu on 4/24/21.
//

import SwiftUI

struct Park: Hashable, Codable, Identifiable {
    
    var id: UUID
    var name: String
    var ticketPrice: Double
    var latitude: Double
    var longitude: Double
    var description: String
    var website: String
    var state: String
    //var contacts: String
    var parkImage: String
    var parkType: String
    
}
