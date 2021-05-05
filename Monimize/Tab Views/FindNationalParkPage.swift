//
//  FindNationalParkPage.swift
//  Monimize
//
//  Created by Ray Liu on 4/25/21.
//


import SwiftUI

let nationalParkActivityList = [ "Arts and Culture", "Astronomy", "Auto and ATV", "Biking" , "Boating", "Camping","Canyoneering", "Caving","Climbing", "Compass and GPS","Dog Sledding" ,"Fishing" ,"Flying" ,"Food" ,"Golfing" ,"Guided Tours" ,"Hands-On" ,"Hiking" ,"Horse Trekking" ,"Hunting and Gathering","Ice Skating" ,"Junior Ranger Program","Living History","Museum Exhibits","Paddling","Park Film" ,"Playground" ,"SCUBA Diving","Shopping","Skiing" ,"Snorkeling" ,"Snow Play" ,"Snowmobiling" ,"Snowshoeing" ,"Surfing" ,"Swimming" ,"Team Sports","Tubing" ,"Water Skiing","Wildlife Watching"]



struct FindNationalParkPage: View {


    @State private var selectedIndexFrom = 10
    @State private var searchCompleted = false
    @State private var searchActivity = ""
    @State private var showProgressView = false

    var body: some View {

            ZStack {

                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)

            Form {

                Section(header: Text("Select An Activity You'd Like to Do")) {

                    Picker("Selected Activity:", selection: $selectedIndexFrom) {

                        ForEach(0 ..< nationalParkActivityList.count, id: \.self) {

                            Text(nationalParkActivityList[$0])

                        }
                    }

                    .frame(minWidth: 300, maxWidth: 500)
                }
                
                Section(header: Text("SEARCH NATIONAL PARKS CONTAINING THE SELECTED ACTIVITY")) {
                    HStack {
                        Button(action: {
                            if self.inputDataValidated() {
                                self.showProgressView = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.searchApi()
                                self.showProgressView = false
                                self.searchCompleted = true
                                }

                            } else {
                                //
                            }

                        }) {
                            Text(self.searchCompleted ? "Search Completed" : "Search")
                        }
                        .frame(width: 240, height: 36, alignment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(Color.black, lineWidth: 1)
                        )
                    }   // End of HStack

                }
                
                if showProgressView{
                    Section{
                        ProgressView()
                            .progressViewStyle(DarkBlueShadowProgressViewStyle())
                    }
                }
                
                if searchCompleted {

                    Section(header: Text("Show NATIONAL PARKS FOUND")) {

                        NavigationLink(destination: showSearchResults) {

                            HStack {

                                Image(systemName: "list.bullet")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                    .foregroundColor(.blue)

                                Text("Show NATIONAL PARKS Found")

                                    .font(.system(size: 16))

                            }

                        }

                        .frame(minWidth: 300, maxWidth: 500)

                    }

                }
                if (self.searchCompleted)
                {
                    
                    Section(header: Text("CLEAR (Please Clear Before Searching Another Activity!)")) {
                        HStack {
                            Button(action: {
                                self.searchActivity = ""
                                self.selectedIndexFrom = 10
                                parkIDList.removeAll()
                                parkResultsList.removeAll()
                                self.searchCompleted = false

                            }) {
                                Text("Clear")
                            }
                            .frame(width: 120, height: 36, alignment: .center)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(Color.black, lineWidth: 1)
                            )
                        }   // End of HStack

                    }
                    
                    
                    
                }
                



            }   // End of Form

                .navigationBarTitle(Text("Plan A Trip To A National Park"), displayMode: .inline)

               

            }   // End of ZStack

                 .customNavigationViewStyle()  // Given in NavigationStyle.swift

    }
    
    func searchApi() {

        // Remove spaces, if any, at the beginning and at the end of the entered search query string


        // Public function obtainCountryDataFromApi is given in CountryApiData.swift
        
        parkResultsList.removeAll()
        parkIDList.removeAll()
        
        let searchQuery = nationalParkActivityList[self.selectedIndexFrom]

        obtainNationalParkDataFromApi(category:"Activity", query: searchQuery)
        
        cashInIDSearchList()
        
    }

    
    
    func inputDataValidated() -> Bool {

        return true
    }
    
    var notFoundMessage: some View {

        VStack {

            Image(systemName: "exclamationmark.triangle")

                .imageScale(.large)

                .font(Font.title.weight(.medium))

                .foregroundColor(.red)

                .padding()

            Text("No National Park Found! Please enter another activity!")

                .fixedSize(horizontal: false, vertical: true)   // Allow lines to wrap around

                .multilineTextAlignment(.center)

                .padding()

        }

        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        .background(Color(red: 1.0, green: 1.0, blue: 240/255))     // Ivory color

    }
    
    var showSearchResults: some View {

        // Global variable countryFound is given in CountryApiData.swift

        if parkResultsList.isEmpty {
            return AnyView(notFoundMessage)
        }

        return AnyView(ParkSearchResutsList())

    }


}

   

   


  

    



 
