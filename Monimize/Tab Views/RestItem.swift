//
//  RestItem.swift
//  Monimize
//
//  Created by Ray Liu on 5/4/21.
//

import SwiftUI

struct RestItem: View {
    // Input Parameter
    let rest: Rest
   
    var body: some View {
        HStack {
            // Public function getImageFromUrl is given in UtilityFunctions.swift
            getImageFromUrl(url: rest.image, defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
           
            VStack(alignment: .leading) {
                Text("Name: \(rest.name)")
                //Text("Rating: \(rest.rating)")
                HStack{
                    Text("Rating:")
                    stars(starNum: Int(truncating: NSNumber(value: rest.rating)))
                }
                
                Text("Price: \(givePricing())")
                
            }
            .font(.system(size: 14))
           
        }   // End of HStack
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
    
    
}

struct ratings: View {
    
    let starNum : Int
    
    var body: some View{
        
        HStack(spacing: 2){
           ForEach(0..<starNum) { _ in
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 13, height: 13)
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(.gray)
                        }
            Spacer()
            
        }
    }
}
 


