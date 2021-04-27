//
//  Budgets.swift
//  Monimize
//
//  Created by Eric Li on 4/26/21.
//

import SwiftUI

struct Budgets: View {
    @State private var showBudgetSettings = false
    @State private var flag = false
    var body: some View {
        if flag != true {
            VStack {
                Text("You should create budgets in order to kepp track of your expenses in specific areas like Car Expenses, House expenses, Food expenses, and so on. Click the New Budget button to start.")
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .padding()
                
                Button(action: {
                    self.showBudgetSettings.toggle()
                }) {
                    HStack {
                        Image(systemName: "plus")
                            //.frame(width: 360)
                            .foregroundColor(.blue)
                            
                        Text("New Budget")
                            
                            .foregroundColor(.blue)
                    }
                    .frame(width: 320, height: 50)
                    .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))

                }
                .cornerRadius(24.0)
                .actionSheet(isPresented: $showBudgetSettings, content: { budgetSettings })
            }
            
            
        } else {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
       
    }
    
    var budgetSettings: ActionSheet {
        ActionSheet(title: Text("Budget Settings"),
                    //message: Text("Select Map Type"),
                    buttons: [
                        .default(Text("Expense")) {
                            self.flag = true
                            self.showBudgetSettings = false
                        },
                        .default(Text("Income")) {
                            //self.selectedMapType = MKMapType.satellite
                            self.showBudgetSettings = false
                        },
                        
                        .cancel() {
                            self.showBudgetSettings = false
                        }
                    ])
    }
}

struct Budgets_Previews: PreviewProvider {
    static var previews: some View {
        Budgets()
    }
}
