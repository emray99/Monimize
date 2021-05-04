//
//  PasswordSet.swift
//  Monimize
//
//  Created by Ray Liu on 5/3/21.
//

import SwiftUI
 
struct Settings: View {
   
    @State private var passwordEntered = ""
    @State private var passwordVerified = ""
    @State private var questionEntered = ""
    @State private var showPassword = false
    @State private var showUnmatchedPasswordAlert = false
    @State private var showPasswordSetAlert = false
    @State private var selectedIndexFrom = 4
    
    @EnvironmentObject var userData: UserData
    
    let securityQuestionList = ["In what city or town did your mother and father meet?", "In what city or town were you born?", "What did you want to be when you grew up?", "What do you remember most from your childhood?", "What is the name of the boy or girl that you first kissed?", "What is the name of your favorite childhood friend?","What is the name of your first pet?","what is your mother's maiden name?","What was your favorite place to visit as a child?"]
   
    var body: some View {
        NavigationView{
        ZStack {
            Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            Form  {
            //VStack {
                
                Section(header: Text("Show/Hide Entered Values")) {
                    Toggle(isOn: $showPassword) {
                        Text("Show Entered Values")
                    }
                }
                
                Section(header: Text("Select Security Question")) {
                    Picker("Selected:", selection: $selectedIndexFrom) {
                        ForEach(0 ..< securityQuestionList.count, id: \.self) {
                            Text(securityQuestionList[$0])
                        }
                    }
                    .frame(minWidth: 300, maxWidth: 500)
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
                
                
                
            Section(header: Text("Enter Password")) {
                HStack{
                if self.showPassword {
                    TextField("Enter Password", text: $passwordEntered)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 250, height: 36)
                        .padding()
                } else {
                    SecureField("Enter Password", text: $passwordEntered)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 250, height: 36)
                        .padding()
                }
                    Button(action: {
                    self.passwordEntered = ""
                    //self.showMissingInputDataAlert = false
                    //self.searchCompleted = false
                }) {
                    Image(systemName: "clear")
                        .imageScale(.medium)
                        .font(Font.title.weight(.regular))
                }
                }
            }
                
        
               
               
            Section(header: Text("Verify Password")) {
                HStack{
                if self.showPassword {
                    TextField("Verify Password", text: $passwordVerified)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 250, height: 36)
                        .padding()
                        //.padding(.bottom, 20)
                } else {
                    SecureField("Verify Password", text: $passwordVerified)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 250, height: 36)
                        .padding()
                        //.padding(.bottom, 20)
                }
                    Button(action: {
                    self.passwordVerified = ""
                    //self.showMissingInputDataAlert = false
                    //self.searchCompleted = false
                }) {
                    Image(systemName: "clear")
                        .imageScale(.medium)
                        .font(Font.title.weight(.regular))
                }
                }
            }
               
            Section(header: Text("Set Password")) {
                Button(action: {
                    if !passwordEntered.isEmpty {
                        if passwordEntered == passwordVerified {
                            /*
                             UserDefaults provides an interface to the user’s defaults database,
                             where you store key-value pairs persistently across launches of your app.
                             */
                            // Store the password in the user’s defaults database under the key "Password"
                            UserDefaults.standard.set(self.passwordEntered, forKey: "Password")
                            UserDefaults.standard.set(self.questionEntered, forKey: "QuestionAnswer")
                            UserDefaults.standard.set(self.securityQuestionList[selectedIndexFrom], forKey: "SecurityQuestion")
                           
                            self.passwordEntered = ""
                            self.passwordVerified = ""
                            self.showPasswordSetAlert = true
                            userData.passwordResetting = false
                        } else {
                            self.showUnmatchedPasswordAlert = true
                        }
                    }
                }) {
                    Text("Set Password to Unlock App")
                        .frame(width: 300, height: 36, alignment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(Color.black, lineWidth: 1)
                        )
                }
                .alert(isPresented: $showUnmatchedPasswordAlert, content: { self.unmatchedPasswordAlert })
            }
 
            //}   // End of VStack
        }   // End form
            .alert(isPresented: $showPasswordSetAlert, content: { self.passwordSetAlert })
        }   // End of ZStack
    }
    }   // End of var
   
    /*
     --------------------------
     MARK: - Password Set Alert
     --------------------------
     */
    var passwordSetAlert: Alert {
        Alert(title: Text("Password Set!"),
              message: Text("Password you entered is set to unlock the app!"),
              dismissButton: .default(Text("OK")) )
    }
   
    /*
     --------------------------------
     MARK: - Unmatched Password Alert
     --------------------------------
     */
    var unmatchedPasswordAlert: Alert {
        Alert(title: Text("Unmatched Password!"),
              message: Text("Two entries of the password must match!"),
              dismissButton: .default(Text("OK")) )
    }
}
 
struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
