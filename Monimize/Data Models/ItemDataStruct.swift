//
//  ItemDataStruct.swift
//  Monimize
//
//  Created by Ray Liu on 4/20/21.
//

/*"itemName": "new Macbook",
"itemCost": 1099.99,
"itemDescription": "Awesome Macbook gotta buy",
"itemLocation": "Apple store nearby",
"purchaseTime": "2021-10-04",
"trailerID": "5sEaYB4rLFQ",
"photoFilename": "ApplePark",
"photoLatitude": 0.00,
"photoLongitude": 0.00*/

import Foundation
 
struct Expense: Decodable {
    
    var itemName: String
    var itemCost: Double
    var itemDescription: String
    var itemLocation: String
    var purchaseTime: String
    var trailerID: String
    var photoFilename: String
    var photoLatitude: Double
    var photoLongitude: Double
    

}
