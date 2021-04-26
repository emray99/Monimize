//
//  SavingStruct.swift
//  Monimize
//
//  Created by Guo Yang on 4/26/21.
//

import Foundation
 
struct SavingStruct: Decodable {
    
    var expectDate: String
    var currentSave: Double
    var budgetValue: Double
    var budgetName: String
    var budgetDescription: String
    var photoFilename: String
    var photoLatitude: Double
    var photoLongitude: Double
    

}
