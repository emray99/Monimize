//
//  SearchResultsEmpty.swift
//  Monimize
//
//  Created by Ray Liu on 4/20/21.
//

import SwiftUI

struct SearchResultsEmpty: View {
    var body: some View {
        ZStack {    // Color Background to Ivory color
            Color(red: 1.0, green: 1.0, blue: 240/255).edgesIgnoringSafeArea(.all)
            
            VStack {
                Image(systemName: "exclamationmark.triangle")
                    .imageScale(.large)
                    .font(Font.title.weight(.medium))
                    .foregroundColor(.red)
                    .padding()
                Text("Database Search Produced No Results!\n\nDatabase search did not return any value for the given query!")
                    .fixedSize(horizontal: false, vertical: true)   // Allow lines to wrap around
                    .multilineTextAlignment(.center)
                    .padding()
            } // End of VStack
            
        } // End of ZStack
    }
}

struct SearchResultsEmpty_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsEmpty()
    }
}
