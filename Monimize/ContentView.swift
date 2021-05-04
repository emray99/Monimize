//
//  ContentView.swift
//  Monimize
//
//  Created by Ray Liu on 4/18/21.
//

import SwiftUI
import LocalAuthentication
 
struct ContentView : View {
   
    // Subscribe to changes in UserData
    @EnvironmentObject var userData: UserData
   
    var body: some View {
        ZStack{
            if userData.userAuthenticated {
               MainView()
            } else
            {
                LoginView()
            }
        }
        .onAppear(perform: authenticate)
        
        
        
        
       
    }
    
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // 鉴权完成
                DispatchQueue.main.async {
                    if success {
                        userData.userAuthenticated = true
                    } else {
                        userData.userAuthenticated = false
                    }
                }
            }
        } else {
            // 没有生物特征识别功能
        }
    }
    
}
 
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


