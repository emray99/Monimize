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
                    Text(rest.price)
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
