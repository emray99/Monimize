//
//  PasswordReset.swift
//  Monimize
//
//  Created by Ray Liu on 5/3/21.
//

import SwiftUI
 
struct PasswordReset: View {
   
    @State private var passwordEntered = ""
    @State private var passwordVerified = ""
    @State private var questionEntered = ""
    @State private var showPassword = false
    @State private var showUnmatchedPasswordAlert = false
    @State private var showPasswordSetAlert = false
    @State private var selectedIndexFrom = 0
    
   
    var body: some View {

        ZStack {
            Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            Form  {
            //VStack {
                
                Section(header: Text("Show/Hide Entered Values")) {
                    Toggle(isOn: $showPassword) {
                        Text("Show Entered Values")
                    }
                }
                
                Section(header: Text("Security Question")) {
                    Text(UserDefaults.standard.string(forKey: "SecurityQuestion")!)
                    
                }
                
                Section(header: Text("Enter Answer to Selected Security QUestion")) {
                    HStack{
                    if self.showPassword {
                        TextField("Enter Answer", text: $questionEntered)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 250, height: 36)
                            .padding()
                            //.padding(.bottom, 20)
                    } else {
                        SecureField("Enter Answer", text: $questionEntered)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 250, height: 36)
                            .padding()
                            //.padding(.bottom, 20)
                    }
                        Button(action: {
                            self.questionEntered = ""
                            //self.showMissingInputDataAlert = false
                            //self.searchCompleted = false
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                
                if(questionEntered == UserDefaults.standard.string(forKey: "QuestionAnswer")){
                    Section(header: Text("Incorrect Answer")) {
                        NavigationLink(destination: Settings()){
                            HStack {
                                Image(systemName: "gear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                    .foregroundColor(.blue)
                                Text("Show Settings")
                                    .font(.system(size: 16))
                            }
                        }
                    }
                } else{
                    Section(header: Text("Incorrect Answer")) {
                        Text("Answer to the Security Question is incorrect!")
                }
 
            //}   // End of VStack
        }   // End form
        //.navigationBarTitle(Text("Search Cocktails"), displayMode: .inline)
        }
    }   // End of ZStack
    
        
   
    /*
     --------------------------------
     MARK: - Unmatched Password Alert
     --------------------------------
     */

}

struct PasswordReset_Previews: PreviewProvider {
    static var previews: some View {
        PasswordReset()
    }
}
}
