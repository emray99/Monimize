//
//  AddSavingPlan.swift
//  Monimize
//
//  Created by Guo Yang on 4/26/21.
//

import SwiftUI
import CoreData
 
struct AddSavingPlan: View {
   
    // Enable this View to be dismissed to go back when the Save button is tapped
    @Environment(\.presentationMode) var presentationMode
   
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
   
    @State private var showSongAddedAlert = false
    @State private var showInputDataMissingAlert = false
   
    // savingItem Entity
    @State private var planTitle = ""
    @State private var currentMoney = 0.0
    @State private var planDescription = "\n \n \n "
    @State private var exceptDate = Date()
    @State private var targetMoney = 0.0
   
    // saving Item photo
    @State private var showImagePicker = false
    @State private var photoImageData: Data? = nil
    @State private var photoTakeOrPickIndex = 1     // Pick from Photo Library
   
    var photoTakeOrPickChoices = ["Camera", "Photo Library"]
   
    var dateClosedRange: ClosedRange<Date> {
        // Set minimum date to 20 years earlier than the current year
        let minDate = Calendar.current.date(byAdding: .year, value: -20, to: Date())!
       
        // Set maximum date to 2 years later than the current year
        let maxDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())!
        return minDate...maxDate
    }
    
    let costFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSize = 3
        return numberFormatter
        
    }()
   
    var body: some View {
        NavigationView{
        Form {
            Group {
                Section(header: Text("Plan title")) {
                    TextField("Enter a title for your budget plan", text: $planTitle)
                }
                Section(header: Text("Saving Target")) {
                    TextField("0", value: $targetMoney, formatter: costFormatter)
                }
              
                Section(header: Text("Current Saved Money")) {
                    TextField("0", value: $currentMoney, formatter: costFormatter)
                }
                
                Section(header: Text("Plan description"), footer:
                                        Button(action: {
                                            self.dismissKeyboard()
                                        }) {
                                            Image(systemName: "keyboard")
                                                .font(Font.title.weight(.light))
                                                .foregroundColor(.blue)
                                        }
                            ) {
                                TextEditor(text: $planDescription)
                                    .frame(height: 100)
                                    .font(.custom("Helvetica", size: 14))
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                            }

                Section(header: Text("Expect Finish Date")) {
                    DatePicker(
                        selection: $exceptDate,
                        in: dateClosedRange,
                        displayedComponents: .date) {
                            Text("Target Date")
                        }
                }
                


                    
            }   // End of Group
            .alert(isPresented: $showSongAddedAlert, content: { self.songAddedAlert })
            Group {

                Section(header: Text("Add plan Photo")) {
                    VStack {
                        Picker("Take or Pick Photo", selection: $photoTakeOrPickIndex) {
                            ForEach(0 ..< photoTakeOrPickChoices.count, id: \.self) {
                                Text(self.photoTakeOrPickChoices[$0])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                       
                        Button(action: {
                            self.showImagePicker = true
                        }) {
                            Text("Get Photo")
                                .padding()
                        }
                    }   // End of VStack
                }
                Section(header: Text("Plan Photo")) {
                    photoImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100.0, height: 100.0)
                    Spacer()
                }
            }   // End of Group
 
        }   // End of Form
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .autocapitalization(.words)
        .disableAutocorrection(true)
        .font(.system(size: 14))
        .alert(isPresented: $showInputDataMissingAlert, content: { self.inputDataMissingAlert })
        .navigationBarTitle(Text("Add Budget Plan"), displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                if self.inputDataValidated() {
                    self.saveNewSong()
                    self.showSongAddedAlert = true
                } else {
                    self.showInputDataMissingAlert = true
                }
            }) {
                Text("Save")
            })
       
        .sheet(isPresented: self.$showImagePicker) {
            /*
             🔴 We pass $showImagePicker and $photoImageData with $ sign into PhotoCaptureView
             so that PhotoCaptureView can change them. The @Binding keywork in PhotoCaptureView
             indicates that the input parameter is passed by reference and is changeable (mutable).
             */
            PhotoCaptureView(showImagePicker: self.$showImagePicker,
                             photoImageData: self.$photoImageData,
                             cameraOrLibrary: self.photoTakeOrPickChoices[self.photoTakeOrPickIndex])
        }
    }
    
       
    }   // End of body
    
    func dismissKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
   
    var photoImage: Image {
       
        if let imageData = self.photoImageData {
            // The public function is given in UtilityFunctions.swift
            let imageView = getImageFromBinaryData(binaryData: imageData, defaultFilename: "ImageUnavaliable")
            return imageView
        } else {
            return Image("ImageUnavaliable")
        }
    }
   
    /*
     ------------------------
     MARK: - Song Added Alert
     ------------------------
     */
    var songAddedAlert: Alert {
        Alert(title: Text("Budget Plan Added!"),
              message: Text("New budget plan is added to your trip record list."),
              dismissButton: .default(Text("OK")) {
                  // Dismiss this View and go back
                  self.presentationMode.wrappedValue.dismiss()
            })
    }
   
    /*
     --------------------------------
     MARK: - Input Data Missing Alert
     --------------------------------
     */
    var inputDataMissingAlert: Alert {
        Alert(title: Text("Missing Input Data!"),
              message: Text("Required Data: Budget Plan Title"),
              dismissButton: .default(Text("OK")) )
    }
   
    /*
     -----------------------------
     MARK: - Input Data Validation
     -----------------------------
     */
    func inputDataValidated() -> Bool {
 
        if self.planTitle.isEmpty {
            return false
        }
       
        return true
    }
   
    /*
     ---------------------
     MARK: - Save new saving Item
     ---------------------
     */
    func saveNewSong() {
       
        // Instantiate a DateFormatter object
        let dateFormatter = DateFormatter()
       
        // Set the date format to yyyy-MM-dd
        dateFormatter.dateFormat = "yyyy-MM-dd"
       
        // Obtain DatePicker's selected date, format it as yyyy-MM-dd, and convert it to String
        let expectDateString = dateFormatter.string(from: self.exceptDate)

       
        /*
         =====================================================
         Create an instance of the Song Entity and dress it up
         =====================================================
        */
       
        // ❎ Create a new saving Item entity in CoreData managedObjectContext
        let newSavingItem = SavingItem(context: self.managedObjectContext)
       
        // ❎ Dress up the new savingItem entity
        newSavingItem.budgetName = self.planTitle
        newSavingItem.currentSave = NSNumber(value: self.currentMoney)
        newSavingItem.budgetValue = NSNumber(value: self.targetMoney)
        newSavingItem.expectDate = expectDateString
        newSavingItem.budgetDescription = self.planDescription
       
        /*
         ======================================================
         Create an instance of the Photo Entity and dress it up
         ======================================================
        */
       
        // ❎ Create a new Photo entity in CoreData managedObjectContext
        let newPhoto = SavingItemPhoto(context: self.managedObjectContext)
       
        // ❎ Dress up the new Photo entity
        if let imageData = self.photoImageData {
            newPhoto.savingPhoto = imageData
        } else {
            // Obtain the album cover default image from Assets.xcassets as UIImage
            let photoUIImage = UIImage(named: "ImageUnavailable")
           
            // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
            let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
           
            // Assign photoData to Core Data entity attribute of type Data (Binary Data)
            newPhoto.savingPhoto = photoData!
        }
       
        /*
         ==============================
         Establish Entity Relationships
         ==============================
        */
       
        // Establish One-to-One Relationship between Song and Photo
        newSavingItem.savingPhoto = newPhoto
        newPhoto.savingItem = newSavingItem
       
        /*
         =============================================
         MARK: - ❎ Save Changes to Core Data Database
         =============================================
         */
       
        do {
            try self.managedObjectContext.save()
        } catch {
            return
        }
       
    }   // End of function
 
}
 
 
 


