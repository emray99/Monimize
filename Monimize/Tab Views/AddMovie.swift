//
//  AddMovie.swift
//  Monimize
//
//  Created by Ray Liu on 4/25/21.
//

import SwiftUI
import CoreData
 
struct AddMovie: View {
    
    let movie: Movie
   
    // Enable this View to be dismissed to go back when the Save button is tapped
    @Environment(\.presentationMode) var presentationMode
   
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
   
    @State private var showTripAddedAlert = false
    @State private var showInputDataMissingAlert = false
  
    //Item Entity
    @State private var itemCost = 0.00
    @State private var itemName = ""
    @State private var itemLocation = ""
    @State private var itemDescription = ""
    @State private var purchaseTime = Date()
    @State private var trailerID = ""
    
    //Photo Entity
    @State private var latitude = 0.0
    @State private var longitude = 0.0


    @State private var showImagePicker = false
    @State private var photoImageData: Data? = nil
    @State private var photoTakeOrPickIndex = 1     // Pick from Photo Library
   
    

    var photoTakeOrPickChoices = ["Camera", "Photo Library"]
   
    var dateClosedRange: ClosedRange<Date> {
        // Set minimum date to 20 years earlier than the current year
        let minDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())!
       
        // Set maximum date to 2 years later than the current year
        let maxDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        return minDate...maxDate
    }
    
    let tripCostFormatter: NumberFormatter = {

           let numberFormatter = NumberFormatter()
           numberFormatter.numberStyle = .decimal
           numberFormatter.maximumFractionDigits = 2
           numberFormatter.usesGroupingSeparator = true
           numberFormatter.groupingSize = 3

           return numberFormatter

       }()
   
    var body: some View {
        Form {
            Group {
                Section(header: Text("Movie Title")) {
                    Text("Movie: \(movie.title)")
                }
                
                Section(header: Text("Movie Ticket Price (Hit Enter!)")) {
                    TextField("Cost", value: $itemCost, formatter: tripCostFormatter)
                      }
                
              /*  Section(header: Text("Movie Theater Location")) {
                    TextField("Location", text: $itemLocation)
                      } */
                
                
             /*   Section(header: Text("Movie Trailer ID")) {
                    Text("TrailerID: \(movie.youTubeTrailerId)")
                      }*/
                
                
                Section(header: Text("Movie Plan"), footer:
                                       Button(action: {
                                           self.dismissKeyboard()
                                       }) {
                                           Image(systemName: "keyboard")
                                               .font(Font.title.weight(.light))
                                               .foregroundColor(.blue)
                                       }
                           ) {
                               TextEditor(text: $itemDescription)
                                   .frame(height: 100)
                                   .font(.custom("Helvetica", size: 14))
                                   .foregroundColor(.primary)
                                   .multilineTextAlignment(.leading)
                                .autocapitalization(.sentences)
                                    
                           }
                
                
                }// End of Group
            .alert(isPresented: $showTripAddedAlert, content: { self.tripAddedAlert })
            Group {
                
                Section(header: Text("Movie Show Time")) {
                    DatePicker(
                        selection: $purchaseTime,
                        in: dateClosedRange,
                        displayedComponents: .date) {
                            Text("Movie Show Time")
                        }
                }
                
                
                Section(header: Text("Add Movie Photo")) {
                    VStack {
                        /*Picker("Take or Pick Photo", selection: $photoTakeOrPickIndex) {
                            ForEach(0 ..< photoTakeOrPickChoices.count, id: \.self) {
                                Text(self.photoTakeOrPickChoices[$0])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()*/
                       
                        Button(action: {
                            self.showImagePicker = true
                        }) {
                            Text("Get Photo")
                                .padding()
                        }
                    }   // End of VStack
                }
                Section(header: Text("Movie Photo")) {
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
        .navigationBarTitle(Text("Add Movie"), displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                if self.inputDataValidated() {
                    self.saveNewTrip()
                    self.showTripAddedAlert = true
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
       
    }   // End of body
   
    var photoImage: Image {
       
        if let imageData = self.photoImageData {
            // The public function is given in UtilityFunctions.swift
            let imageView = getImageFromBinaryData(binaryData: imageData, defaultFilename: "Leisure")
            return imageView
        } else {
            return Image("Leisure")
        }
    }
   
    /*
     ------------------------
     MARK: - Trip Added Alert
     ------------------------
     */
    var tripAddedAlert: Alert {
        Alert(title: Text("Movie Added!"),
              message: Text("This movie is now saved as an item in the savings list!"),
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
              message: Text("Missing Vital Movie Inforatiom"),
              dismissButton: .default(Text("OK")) )
    }
   
    /*
     -----------------------------
     MARK: - Input Data Validation
     -----------------------------
     */
    func inputDataValidated() -> Bool {
 
        if (self.itemCost == 0.00) {
            return false
        }
       
        return true
    }
   
    /*
     ---------------------
     MARK: - Save New Trip
     ---------------------
     */
    func saveNewTrip() {
       
        // Instantiate a DateFormatter object
        let dateFormatter = DateFormatter()
       
        // Set the date format to yyyy-MM-dd
        dateFormatter.dateFormat = "yyyy-MM-dd"
       
        // Obtain DatePicker's selected date, format it as yyyy-MM-dd, and convert it to String
        let purchaseTimeString = dateFormatter.string(from: self.purchaseTime)
        
        
        /*
         =====================================================
         Create an instance of the Trip Entity and dress it up
         =====================================================
        */
        
        let newSavings = SavingItem(context: self.managedObjectContext)
        
        newSavings.budgetDescription = self.itemDescription
        newSavings.budgetName = "Movie: \(movie.title)"
        newSavings.budgetValue = NSNumber(value: self.itemCost)
        newSavings.currentSave = 0
        newSavings.expectDate = purchaseTimeString
        
        
        // ❎ Create a new Photo entity in CoreData managedObjectContext
        let newPhoto = SavingItemPhoto(context: self.managedObjectContext)
       
        // ❎ Dress up the new Photo entity
        if let imageData = self.photoImageData {
            newPhoto.savingPhoto = imageData
        } else {
            // Obtain the album cover default image from Assets.xcassets as UIImage
            let photoUIImage = UIImage(named: "Leisure")
           
            // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
            let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
           
            // Assign photoData to Core Data entity attribute of type Data (Binary Data)
            newPhoto.savingPhoto = photoData!
        }
        
        newPhoto.savingLatitude = 0.0
        newPhoto.savingLongitude = 0.0
        
        newSavings.savingPhoto = newPhoto
        newPhoto.savingItem = newSavings
       
     
        do {
            try self.managedObjectContext.save()
        } catch {
            return
        }
       
    }   // End of function
    
    
    func dismissKeyboard() {

            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

        }
    
    var dateAndTimeFormatter: DateFormatter {
           let formatter = DateFormatter()
           formatter.dateStyle = .full     // e.g., Monday, June 29, 2020
           formatter.timeStyle = .short    // e.g., 5:19 PM
           return formatter
       }
 
}
 
 
 

