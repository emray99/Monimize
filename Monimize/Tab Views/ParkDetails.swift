//
//  ParkDetails.swift
//  Monimize
//
//  Created by Ray Liu on 4/25/21.
//

import SwiftUI
import MapKit
import CoreData

struct ParkDetails: View {
   
    @EnvironmentObject var userData: UserData
    
    @State private var showParkAddedAlert = false
    @State private var selectedMapTypeIndex = 0
    @Environment(\.managedObjectContext) var managedObjectContext

    var mapTypes = ["Standard", "Satellite", "Hybrid"]
    
   
    // Input Parameter
    let park: Park
   
    var body: some View {
        // A Form cannot have more than 10 Sections.
        // Group the Sections if more than 10.
        Form {
           
                Section(header: Text("National Park Name"))
                {
                    Text(park.name)
                }
            
                Section(header: Text("National Park Image"))
                {
                    getImageFromUrl(url: park.parkImage, defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                       .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                        .padding()
                }
            
                Section(header: Text("National Park Description"))
                {
                    Text(park.description)
                }
            
                Section(header: Text("Info-Website")) {

                    Link(destination: URL(string: park.website)!) {

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
            
            Section(header: Text("National Park One-time Entrance Fee"))
            {
                Text(giveGoodCost())
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

                NavigationLink(destination: ParkLocationOnMap) {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))

                        Text("Show National Park Location on Map")
                            .font(.system(size: 16))
                    }

                    .foregroundColor(.blue)
                }

                .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
            }
            
            Section(header: Text("Add This National Park As A Future Trip!")) {

                    Button(action: {
                                    self.saveNewTrip()
                                    self.showParkAddedAlert = true
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
        
    
                
        }   // End of Form
            .navigationBarTitle(Text("National Park Details"), displayMode: .inline)
            .font(.system(size: 14))
        .alert(isPresented: $showParkAddedAlert, content: {self.cocktailAddedAlert})
       
    }   // End of body
    
    func saveNewTrip() {
       
        let newSavings = SavingItem(context: self.managedObjectContext)
        
        newSavings.budgetDescription = park.description
        newSavings.budgetName = "A trip to \(park.name)"
        newSavings.budgetValue = NSNumber(value: (park.ticketPrice + 300))
        newSavings.currentSave = 0
        newSavings.expectDate = "Future Travel!"
        

        
        let newPhoto = SavingItemPhoto(context: self.managedObjectContext)
       
        // ??? Dress up the new Photo entity
    
            // Obtain the album cover default image from Assets.xcassets as UIImage
            let photoUIImage = UIImage(named: "Automobile")
           
            // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
            let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
           
            // Assign photoData to Core Data entity attribute of type Data (Binary Data)
        newPhoto.savingPhoto = photoData!
        newPhoto.savingLatitude = NSNumber(value: park.latitude)
        newPhoto.savingLongitude = NSNumber(value: park.longitude)
        
       
        newSavings.savingPhoto = newPhoto
        newPhoto.savingItem = newSavings
       
        /*
         =============================================
         MARK: - ??? Save Changes to Core Data Database
         =============================================
         */
       
        do {
            try self.managedObjectContext.save()
        } catch {
            return
        }
       
    }   // End of function

   
    var cocktailAddedAlert: Alert {

            Alert(title: Text("Trip Added!"),

                  message: Text("This National Park is now added as an item in the savings list as a future trip! The budget is initially set to park entry fee + $300"),

                  dismissButton: .default(Text("OK")) )

        }
    
    var ParkLocationOnMap: some View {
        
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

        return AnyView( MapView(mapType: mapType, latitude: park.latitude, longitude: park.longitude, delta: 10.0, deltaUnit: "degrees", annotationTitle: park.name, annotationSubtitle: "")

                .navigationBarTitle(Text("\(park.name) Location"), displayMode: .inline)

                .edgesIgnoringSafeArea(.all) )

    }
    
    func giveGoodCost() -> String {
        
        var goodCost = ""
        
        if (park.ticketPrice == 0)
        {
            goodCost = "Free Entry"
        }
        else
        {
            goodCost = String(format: "%.2f", park.ticketPrice)
        }
       
        
        return goodCost
        
    }
    
}
 


