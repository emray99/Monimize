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
                
                NavigationLink(destination: showRecentMovies) {

                    HStack {

                        Image(systemName: "film.fill")
                            .imageScale(.large)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)

                        Text("Find a movie!")
                            .font(.system(size: 20))

                    }

                }.padding(.trailing, 100)
                    
                    NavigationLink(destination: NewsListPage()) {

                        HStack {

                            Image(systemName: "newspaper")
                                .imageScale(.large)
                                .font(Font.title.weight(.regular))
                                .foregroundColor(.blue)

                            Text("Read the lastest news!")
                                .font(.system(size: 20))

                        }

                    }.padding(.trailing, 100)
                    
                    NavigationLink(destination: SearchRestPage()) {

                        HStack {

                            Image(systemName: "flame")
                                .imageScale(.large)
                                .font(Font.title.weight(.regular))
                                .foregroundColor(.blue)

                            Text("   Find a Restaurant!")
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
    
    var showRecentMovies: some View {
        
        obtainTmdbDataFromApi(category: "Recent", query: "")
        cashInIDSearchList(category: "Recent")
        
        return AnyView(NowPlayingList())

    }


}

 



