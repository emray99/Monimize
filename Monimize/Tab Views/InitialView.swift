//
//  InitialView.swift
//  Monimize
//
//  Created by Eric Li on 4/27/21.
//

import SwiftUI

struct InitialView: View {
    @State private var showSheet = false
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .center) {
                    Text("You should create budgets in order to keep track of your expenses in specific areas like Car Expenses, House expenses, Food expenses, and so on. Click the New Expense button to start.")
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .padding(.top, 200)
                        .padding()
                    Button(action: {self.showSheet.toggle()}) {
                        HStack {
                            Image(systemName: "plus")
                                //.frame(width: 360)
                                .foregroundColor(.blue)
                                
                            Text("New Expense")
                                
                                .foregroundColor(.blue)
                        }
                        .frame(width: 320, height: 50)
                        .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
                    }
                    .sheet(isPresented: $showSheet) {
                        AddBudget2()
                    }
//                    NavigationLink(destination: AddBudget()) {
//                        HStack {
//                            Image(systemName: "plus")
//                                //.frame(width: 360)
//                                .foregroundColor(.blue)
//
//                            Text("New Budget")
//
//                                .foregroundColor(.blue)
//                        }
//                        .frame(width: 320, height: 50)
//                        .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
//                    }
                    .cornerRadius(24.0)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
//    var budgetSettings: ActionSheet {
//        ActionSheet(title: Text("Budget Settings"),
//                    //message: Text("Select Map Type"),
//                    buttons: [
//                        .default(Text("Expense"),action: self.showSheet.toggle()) {
//                            //self.flag = true
//                            
//                            //self.showBudgetSettings = false
//                        }.sheet(isPresented: $showSheet) {
//                            AddBudget()
//                        },
//                        .default(Text("Income")) {
//                            //self.selectedMapType = MKMapType.satellite
//                            self.showBudgetSettings = false
//                        },
//
//                        .cancel() {
//                            self.showBudgetSettings = false
//                        }
//                    ])
//    }
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
    }
}
