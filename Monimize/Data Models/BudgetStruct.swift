//
//  BudgetStruct.swift
//  Monimize
//
//  Created by Eric Li on 4/27/21.
//

import Foundation



struct BudgetStruct: Decodable {
    
    var title: String
    var currency: String
    var amount: Double
    var note: String
    var category: String
    var audioFilename: String
    var date: String
    var photoFilename: String
    var photoLatitude: Double
    var photoLongitude: Double
    

}
