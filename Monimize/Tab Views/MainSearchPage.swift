//
//  MainSearchPage.swift
//  Monimize
//
//  Created by Ray Liu on 4/25/21.
//

import SwiftUI

struct MainSearchPage: View {

    var body: some View {

        // Specify NavigationView on top containing ZStack and VStack

        NavigationView {

            ScrollView{
            ZStack {    // Background View

                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image("SearchCocktails")
                    .resizable()
                    .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .aspectRatio(contentMode: .fit)
                        .padding(.top, 30)
            
                VStack (alignment: .leading){    // Foreground View
                

                
                NavigationLink(destination: FindMoviePage()) {

                    HStack {

                        Image(systemName: "film.fill")

                            .imageScale(.large)

                            .font(Font.title.weight(.regular))

                            .foregroundColor(.blue)

                        Text("Find a movie!")

                            .font(.system(size: 20))

                    }

                }.padding(.trailing, 100)
                
                NavigationLink(destination: FindNationalParkPage()) {

                    HStack {

                        Image(systemName: "car")

                            .imageScale(.large)

                            .font(Font.title.weight(.regular))

                            .foregroundColor(.blue)

                        Text("Plan a trip to national park!")

                            .font(.system(size: 20))

                    }

                }
                .padding(.trailing, 80)
                .navigationBarTitle(Text("Plan an Activity"), displayMode: .inline)
                .padding(.bottom, 500)


            }   // End of VStack
            .customNavigationViewStyle()

            }   // End of ZStack
            }

        }   // End of NavigationView
    }
        
    }

}

 



/*import SwiftUI

struct MainSearchPage: View {

    var body: some View {

        // Specify NavigationView on top containing ZStack and VStack

        NavigationView {

            ScrollView{
            ZStack {    // Background View

                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)

            VStack {    // Foreground View
                
                Image("SearchCocktails")
                .resizable()
                .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .aspectRatio(contentMode: .fit)
                    .padding(.top, 30)
                
                NavigationLink(destination: FindMoviePage()) {

                    HStack {

                        Image(systemName: "magnifyingglass.circle")
                            .imageScale(.large)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)

                        Text("Find a good movie to watch!")
                            .font(.system(size: 16))

                    }

                }.padding(.trailing, 100)
                
                NavigationLink(destination: FindNationalParkPage()) {

                    HStack {

                        Image(systemName: "doc.text.magnifyingglass")
                            .imageScale(.large)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)

                        Text("Plan a trip to a national park!")
                            .font(.system(size: 16))

                    }

                }.padding(.trailing, 70)
                


            }   // End of VStack
            .customNavigationViewStyle()

            }   // End of ZStack
          

        }   // End of NavigationView
    }
        
    }

}*/

 
