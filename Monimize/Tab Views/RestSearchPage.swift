//
//  RestSearchPage.swift
//  Monimize
//
//  Created by Ray Liu on 5/4/21.
//

import SwiftUI

struct SearchRestPage: View {

    @State private var searchFieldValue = ""
    @State private var showMissingInputDataAlert = false
    @State private var searchCompleted = false
    @State private var showProgressView = false
    var body: some View {
        
            ZStack {
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
                Group{
                    Form {
                        Section(header: Text("Search For a Restaurant Within 25 Miles"))
                        {
                            HStack {
                                TextField("Enter something you want to eat", text: $searchFieldValue)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .disableAutocorrection(true)

                                // Button to clear the text field

                                Button(action: {
                                    self.searchFieldValue = ""
                                    self.showMissingInputDataAlert = false
                                    self.searchCompleted = false
                                }) {

                                    Image(systemName: "clear")
                                        .imageScale(.medium)
                                        .font(Font.title.weight(.regular))
                                }

                            }   // End of HStack

                                .frame(minWidth: 300, maxWidth: 500)
                        }

                        Section(header: Text("Search Restaurants")) {
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

                                        self.showMissingInputDataAlert = true

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
                        
                        if showProgressView {

                        Section {
                                    ProgressView()
                                                    // Style defined in ProgressViewStyle.swift given below
                                    .progressViewStyle(DarkBlueShadowProgressViewStyle())
                                        }
                                }
                        

                        if searchCompleted {

                            Section(header: Text("Show RESTAURANTS FOUND")) {

                                NavigationLink(destination: showSearchResults) {

                                    HStack {

                                        Image(systemName: "list.bullet")

                                            .imageScale(.medium)

                                            .font(Font.title.weight(.regular))

                                            .foregroundColor(.blue)

                                        Text("Show Restaurant Found (If API is busy and blank screen is shown please search again!)")

                                            .font(.system(size: 16))

                                    }

                                }

                                .frame(minWidth: 300, maxWidth: 500)

                            }

                        }


                    }   // End of Form
                    .navigationBarTitle("Search For A Restaurant", displayMode: .inline)
                }

                .font(.system(size: 14))

                .alert(isPresented: $showMissingInputDataAlert, content: { self.missingInputDataAlert })
                .customNavigationViewStyle()


            }   // End of ZStack

            .customNavigationViewStyle()  // Given in NavigationStyle.swift

       

    }   // End of body

   

    /*

     ------------------

     MARK: - Search API

     ------------------

     */

    func searchApi() {

        // Remove spaces, if any, at the beginning and at the end of the entered search query string

        let queryTrimmed = self.searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)

        // Public function obtainCountryDataFromApi is given in CountryApiData.swift
        
        restResultsList.removeAll()
        obtainYelpDataFromApi(category: "", query: queryTrimmed)

    }

   

    /*

     ---------------------------

     MARK: - Show Search Results

     ---------------------------

     */

    var showSearchResults: some View {

        // Global variable countryFound is given in CountryApiData.swift

        if restResultsList.isEmpty {
            return AnyView(notFoundMessage)
        }

        return AnyView(RestListPage())

    }

   

    /*

     ---------------------------------

     MARK: - Country Not Found Message

     ---------------------------------

     */

    var notFoundMessage: some View {

        VStack {

            Image(systemName: "exclamationmark.triangle")

                .imageScale(.large)

                .font(Font.title.weight(.medium))

                .foregroundColor(.red)

                .padding()

            Text("No Restaurant Found! Please enter another search query.")

                .fixedSize(horizontal: false, vertical: true)   // Allow lines to wrap around

                .multilineTextAlignment(.center)

                .padding()

        }

        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        .background(Color(red: 1.0, green: 1.0, blue: 240/255))     // Ivory color

    }

   

    /*

     --------------------------------

     MARK: - Missing Input Data Alert

     --------------------------------

     */

    var missingInputDataAlert: Alert {

        Alert(title: Text("Restaurant Search Field is Empty!"),

              message: Text("Please enter a search query!"),

              dismissButton: .default(Text("OK")) )

        /*

         Tapping OK resets @State var showMissingInputDataAlert to false.

         */

    }

   

    /*

     -----------------------------

     MARK: - Input Data Validation

     -----------------------------

     */

    func inputDataValidated() -> Bool {

        // Remove spaces, if any, at the beginning and at the end of the entered search query string
        let queryTrimmed = self.searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if queryTrimmed.isEmpty {

            return false
        }
        return true
    }
    
    

}

 

 
