//
//  UserData.swift
//  Monimize
//
//  Created by Ray Liu on 4/20/21.
//

import SwiftUI

final class UserData: ObservableObject {
  
    // ❎ Subscribe to notification that the managedObjectContext completed a save
    @Published var savedInDatabase =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    //var userAuthenticated = true
    @Published var userAuthenticated = false
    @Published var passwordResetting = false
   
   
 
}
 
