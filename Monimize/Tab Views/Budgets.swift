//
//  Budgets.swift
//  Monimize
//
//  Created by Eric Li on 4/26/21.
//

import SwiftUI

struct Budgets: View {
   
    @State private var flag = false
    @EnvironmentObject var userData: UserData
    var body: some View {
        if userData.userAuthenticated {
            return AnyView(ListView())
        } else {
            return AnyView(InitialView())
        }
       
    }
    
  
    
    
}

struct Budgets_Previews: PreviewProvider {
    static var previews: some View {
        Budgets()
    }
}
