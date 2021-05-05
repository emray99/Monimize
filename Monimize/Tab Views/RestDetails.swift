//
//  RestDetails.swift
//  Monimize
//
//  Created by Ray Liu on 5/4/21.
//

import SwiftUI
import MapKit

struct RestDetails: View {
   
    @State private var selectedMapTypeIndex = 0
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var showCocktailAddedAlert = false

    var mapTypes = ["Standard", "Satellite", "Hybrid"]
    
    // Input Parameter
    let rest: Rest
   
    var body: some View {
        // A Form cannot have more than 10 Sections.
        // Group the Sections if more than 10.
        Form {
            Group {
                Section(header: Text("Restaurant Name")) {
                    Text(rest.name)
                }
                Section(header: Text("Restaurant Image")){
                    getImageFromUrl(url: rest.image , defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                        .padding()
                    
                }
                
                
                Section(header: Text("Restaurant Price")) {
                    Text(givePricing())
                }
                
                
                Section(header: Text("Restaurant Phone")) {
                    Text(rest.phone)
                }
                
                Section(header: Text("Select Map Type")) {

                    Picker("Select Map Type", selection: $selectedMapTypeIndex) {

                        ForEach(0 ..< mapTypes.count, id: \.self) { index in

                           Text(self.mapTypes[index]).tag(index)
                       }
                    }
                    .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)

                    NavigationLink(destination: RestLocationOnMap) {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))

                            Text("Show Restaurant Location on Map")
                                .font(.system(size: 16))
                        }

                        .foregroundColor(.blue)
                    }

                    .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
                }
                
                Section(header: Text("Add This Restaurant As a Future Food Trip!")) {

                        Button(action: {
                                        self.saveNewTrip()
                                        self.showCocktailAddedAlert = true
                                    }) {

                                        HStack {
                                            Image(systemName: "plus")
                                                .imageScale(.medium)
                                                .font(Font.title.weight(.regular))
                                                .foregroundColor(.blue)
                                            Text("Add To Saving Plan")
                                                .font(.system(size: 16))

                                        }
                                    }
                                }
                
                
                
                
                Section(header: Text("Restaurants Website")) {

                    Link(destination: URL(string: rest.website)!) {

                    HStack {

                        Image(systemName: "globe")

                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))

                        Text("Show Website")

                            .font(.system(size: 16))

                    }
                    .foregroundColor(.blue)

                }

            }
                
               
                
                
            }
            .font(.system(size: 14))
           
    }
        .navigationBarTitle(Text(rest.name), displayMode: .inline)
            .font(.system(size: 14))
        .alert(isPresented: $showCocktailAddedAlert, content: {self.cocktailAddedAlert})
        
    
    
}
    func givePricing() -> String
    {
        if (rest.price.count == 0)
        {
            return "Unavailable"
        }
        else
        {
            return rest.price
        }
    }
    func findOutHowCostly() -> Double
    {
        let measurement = rest.price.count
        
        if (measurement == 0)
        {
            return 25.0
        }
        
        var predCost = (measurement - 1) * 10 + 25
        
        
        return Double(predCost)
    }
    
    func saveNewTrip() {
       
        let newSavings = SavingItem(context: self.managedObjectContext)
        newSavings.budgetDescription = "Giving this restaurant a try!"
        newSavings.budgetName = "Visit: \(rest.name)"
        newSavings.budgetValue = NSNumber(value: findOutHowCostly())
        newSavings.currentSave = 0
        newSavings.expectDate = "Future Visit!"

        
        
        let newPhoto = SavingItemPhoto(context: self.managedObjectContext)
       
        // ❎ Dress up the new Photo entity
    
            // Obtain the album cover default image from Assets.xcassets as UIImage
            let photoUIImage = UIImage(named: "Food & Dining")
           
            // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
            let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
           
            // Assign photoData to Core Data entity attribute of type Data (Binary Data)
        newPhoto.savingPhoto = photoData!
        newPhoto.savingLatitude = NSNumber(value: rest.latitude)
        newPhoto.savingLongitude = NSNumber(value: rest.longitude)
        
       
        newSavings.savingPhoto = newPhoto
        newPhoto.savingItem = newSavings
       
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
    
    var cocktailAddedAlert: Alert {

            Alert(title: Text("Restaurant Added!"),

                  message: Text("This restaurant is now added as an item in the savings list as a future food trip! The budget is set based on the suggested price range"),

                  dismissButton: .default(Text("OK")) )

        }
    
    
    var RestLocationOnMap: some View {
        
        var mapType: MKMapType
        
        switch selectedMapTypeIndex {
        case 0:
            mapType = MKMapType.standard
        case 1:
            mapType = MKMapType.satellite
        case 2:
            mapType = MKMapType.hybrid
        default:
            fatalError("Map type is out of range!")

        }

        return AnyView( MapView(mapType: mapType, latitude: rest.latitude, longitude: rest.longitude, delta: 0.005, deltaUnit: "degrees", annotationTitle: rest.name, annotationSubtitle: "")

                .navigationBarTitle(Text("\(rest.name) Location"), displayMode: .inline)

                .edgesIgnoringSafeArea(.all) )

    }


 
}
