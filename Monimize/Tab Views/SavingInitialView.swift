//
//  SavingInitialView.swift
//  Monimize
//
//  Created by Ray Liu on 5/3/21.
//

import SwiftUI

struct SavingInitialView: View {
    @State private var showSheet = false
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .center) {
                    Text("Here you can create a new budget plan to keep track you saving goals. Press New Saving Plan to start.")
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
                                
                            Text("New Saving Plan")
                                
                                .foregroundColor(.blue)
                        }
                        .frame(width: 320, height: 50)
                        .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
                    }
                    .sheet(isPresented: $showSheet) {
                        AddSavingPlan()
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
    

}

