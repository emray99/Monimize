//
//  GadgetMainPage.swift
//  Monimize
//
//  Created by Ray Liu on 4/26/21.
//

import SwiftUI

struct GadgetMainPage: View {

    var body: some View {

        // Specify NavigationView on top containing ZStack and VStack

        NavigationView {

            ScrollView{
            ZStack {    // Background View

                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image("Work")
                    .resizable()
                    .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .aspectRatio(contentMode: .fit)
                        .padding(.top, 30)
                        .padding(.bottom, 50)
            
                VStack (alignment: .leading){    // Foreground View
                
                    NavigationLink(destination: CurrencyConverterPage()) {

                        HStack {

                            Image(systemName: "coloncurrencysign.square")

                                .imageScale(.large)

                                .font(Font.title.weight(.regular))

                                .foregroundColor(.blue)

                            Text("Currency Converter")

                                .font(.system(size: 20))

                        }

                    }.padding(.trailing, 100)
                    
                    NavigationLink(destination: Settings()) {

                        HStack {

                            Image(systemName: "gear")

                                .imageScale(.large)

                                .font(Font.title.weight(.regular))

                                .foregroundColor(.blue)

                            Text("Password Reset")

                                .font(.system(size: 20))

                        }

                    }.padding(.trailing, 100)
                
                NavigationLink(destination: ScanQRBarcode()) {

                    HStack {

                        Image(systemName: "qrcode.viewfinder")

                            .imageScale(.large)

                            .font(Font.title.weight(.regular))

                            .foregroundColor(.blue)

                        Text("QR Code Scanner")

                            .font(.system(size: 20))

                    }

                }
                .padding(.trailing, 80)
                .navigationBarTitle(Text("Gadgets!"), displayMode: .inline)
                .padding(.bottom, 500)


            }   // End of VStack
            .customNavigationViewStyle()

            }   // End of ZStack
            }

        }   // End of NavigationView
    }
        
    }
    

}

 



