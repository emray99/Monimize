//
//  BudgetStruct.swift
//  Monimize
//
//  Created by Eric Li on 4/27/21.
//

import Foundation



public struct BudgetStruct: Hashable, Codable, Identifiable {
    
    public var id: UUID
    var title: String
    var currency: String
    var amount: Double
    var note: String
    var category: String
    var audioFilename: String
    var date: String
    var photoFilename: String
    var latitude: Double
    var longitude: Double
    

}
