//
//  AddBudget.swift
//  Monimize
//
//  Created by Eric Li on 4/27/21.
//

import SwiftUI

struct AddBudget: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.presentationMode) var presentationMode
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var title = ""
    @State private var note = ""
    @State private var value = 0.0
    @State private var showImagePicker = false
    @State private var showCurrencyPicker = false
    @State private var showBudgetAddedAlert = false
    @State private var showInputDataMissingAlert = false
    @State private var photoImageData: Data? = nil
    @State private var photoTakeOrPickIndex = 1
    let currencyList = ["USD", "AUD", "CAD", "EUR", "GBP", "JPY"]
    let currencyDict = ["USD": "$", "AUD": "A$", "CAD": "C$", "EUR": "€", "GBP": "£", "JPY": "¥"]
    let categoryList = ["Automobile", "Bills", "Grocery", "Clothing", "Digital", "Education", "Fees", "Food & Dining" , "Health Care", "Housing", "Leisure", "Loans", "Other"]
    @State private var categoryIndex = 0
    var photoTakeOrPickChoices = ["Camera", "Photo Library"]
    @State private var selectedIndex = 0  // Brandy
    
    let moneyFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSize = 3
        return numberFormatter
    }()
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Describe your budget"), footer:
                            Button(action: {
                                self.dismissKeyboard()

                            }) {
                                Image(systemName: "keyboard")
                                    .font(Font.title.weight(.light))
                                    .foregroundColor(.blue)
                            }) {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "textbox")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 24, weight: .regular))
                            TextField("Name", text: $title)
                                .disableAutocorrection(true)
                                .autocapitalization(.words)
                                .padding(8)
                        }
                        .frame(height: 50)
                        Divider()
                        HStack {
                            Image(systemName: "plusminus.circle")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 26, weight: .regular))
                            TextField("Amount", value: $value, formatter: moneyFormatter)
                                .keyboardType(.numbersAndPunctuation)
        
                            
                            Button(action: {
                                self.showCurrencyPicker = true
                            }) {
                                Text(currencyList[selectedIndex])
                                    .foregroundColor(Color.gray)
                            }
                            .sheet(isPresented: self.$showCurrencyPicker) {
                                Picker("", selection: $selectedIndex){
                                    ForEach(0 ..< currencyList.count, id: \.self) {
                                        Text(currencyList[$0])
                                            .font(.system(size: 26))
                                    }
                                }
                                //.frame(minWidth: 300, maxWidth: 500, alignment: .leading)
                            }
                            
                        }
                        .frame(height: 40)
                        Divider()
                        HStack{
                            Image(systemName: "note.text.badge.plus")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 26, weight: .regular))
                            Text("Add Note for this budget")
                                .foregroundColor(Color.gray)
                        }
                        TextEditor(text: $note)
                            .frame(height: 100)
                            .font(.custom("Helvetica", size: 14))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                    }
                }
                .alert(isPresented: $showBudgetAddedAlert, content: { self.budgetAddedAlert })
                Section(header: Text("Picture for this budget")){
                    Picker("Select Photo Type", selection: $photoTakeOrPickIndex) {
                        ForEach(0 ..< photoTakeOrPickChoices.count, id: \.self) { index in
                           Text(self.photoTakeOrPickChoices[index]).tag(index)
                       }
                    }
                    .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                    .pickerStyle(SegmentedPickerStyle())
                    //.padding(.horizontal)
                    
                    if photoTakeOrPickIndex == 0 {
                        Button(action: {
                            self.showImagePicker = true
                        }) {
                            Text("Get Photo")
                                .padding(.horizontal, 110)
                            
                        }
                        .sheet(isPresented: self.$showImagePicker) {
                            PhotoCaptureView(showImagePicker: self.$showImagePicker,
                                             photoImageData: self.$photoImageData,
                                             cameraOrLibrary: "Camera")
                    }

                    } else {
                        Button(action: {
                            self.showImagePicker = true
                        }) {
                            Text("Get Photo")
                                .padding(.horizontal, 110)
                        }
                        .sheet(isPresented: self.$showImagePicker) {
                            PhotoCaptureView(showImagePicker: self.$showImagePicker,
                                             photoImageData: self.$photoImageData,
                                             cameraOrLibrary: "Photo Library")
                        }
                    }
                    
                }
                
                Section(header: Text("Choose a category for this budget")) {
                    Picker("", selection: $categoryIndex) {
                        ForEach(0 ..< categoryList.count, id: \.self) {
                            Text(self.categoryList[$0])
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
                }
                
            } // End of Form
            .alert(isPresented: $showInputDataMissingAlert, content: { self.inputDataMissingAlert })
            .navigationBarTitle(Text("Add New Expense"), displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    if self.inputDataValidated() {
                        self.addNewBudget()
                        self.showBudgetAddedAlert = true
                    } else {
                        self.showInputDataMissingAlert = true
                    }
                }) {
                    Text("Save")
                })
            .font(.system(size: 14))
        }
        
    }
    var budgetAddedAlert: Alert {
        Alert(title: Text("Trip Added!"),
              message: Text("New expense is added to the list."),
              dismissButton: .default(Text("OK")){
                // Dismiss this Modal View and go back to the previous view in the navigation hierarchy
                self.presentationMode.wrappedValue.dismiss()
              } )
    }
    var inputDataMissingAlert: Alert {
        Alert(title: Text("Missing Input Data!"),
              message: Text("Required Data: Title, Amount."),
              dismissButton: .default(Text("OK")) )
    }
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    func inputDataValidated() -> Bool {
       
        if self.title.isEmpty || self.value == 0 {
            return false
        }
       
        return true
    }
    func addNewBudget() {
        let date = Date()
        let currdateFormatter = DateFormatter()
        currdateFormatter.dateFormat = "yyyy-MM-dd' at 'HH:mm:ss"
        let currentDateTime = currdateFormatter.string(from: date)
        
        
        let newBudget = Budget(context: self.managedObjectContext)
        newBudget.title = self.title
        newBudget.currency = self.currencyList[selectedIndex]
        newBudget.amount = NSNumber(value: self.value)
        newBudget.note = self.note
        newBudget.category = self.categoryList[categoryIndex]
        newBudget.audioFilename = ""
        newBudget.date = currentDateTime
        
        let newPhoto = BudgetPhoto(context: self.managedObjectContext)
        let currentGeolocation = currentLocation()
        if let imageData = self.photoImageData {
            newPhoto.photoData = imageData
            newPhoto.latitude = NSNumber(value: currentGeolocation.latitude)
            newPhoto.longitude = NSNumber(value: currentGeolocation.longitude)
            //newPhoto.date = currentDateTime
            
        } else {
            // Obtain the album cover default image from Assets.xcassets as UIImage
            let photoUIImage = UIImage(named: "ImageUnavailable")
           
            // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
            let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
           
            // Assign photoData to Core Data entity attribute of type Data (Binary Data)
            newPhoto.photoData = photoData!
        }
        
        newBudget.photo = newPhoto
        newPhoto.budget = newBudget
        
        do {
            try self.managedObjectContext.save()
        } catch {
            return
        }
        
    }
}

