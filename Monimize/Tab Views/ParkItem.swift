//
//  ParkItem.swift
//  Monimize
//
//  Created by Ray Liu on 4/25/21.
//

import SwiftUI

struct ParkItem: View {
    // Input Parameter
    let park: Park
    var body: some View {
        HStack {
            getImageFromUrl(url: park.parkImage, defaultFilename: "ImageUnavailable.jpg")
                .resizable()
                .aspectRatio(contentMode: .fit)
                //.frame(width: 128.0, height: 72.0)
                .frame(width: 100)
            
            VStack(alignment: .leading) {
                Text(park.name)
                //Text(park.parkType)
                Text("State: \(park.state)")
            }
            // Set font and size for the whole VStack content
            .font(.system(size: 14))

        }   // End of HStack

    }

}
