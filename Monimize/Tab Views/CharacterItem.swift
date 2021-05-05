//
//  CharacterItem.swift
//  Movies
//
//  Created by Ray Liu on 4/10/21.
//

import SwiftUI

struct CharacterItem: View {
    
    let thisMovie : String
    let actorName : String
    //@State private var asCharacter = ""
    
    var body: some View {
        
        HStack {
            // Public function getImageFromUrl is given in UtilityFunctions.swift
            getImageFromUrl(url: sniffDictionary(), defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
           
            VStack(alignment: .leading) {
                Text(actorName)
                //Text("playing")
                Text(findChar())
             
            }
            .font(.system(size: 14))
           
        }   // End of HStack
        
      
    }
    
    func findChar() -> String {
    
     var asCharacter = ""
        
    if let actorName = newActorDictionary[thisMovie]?[actorName]?[0]
    {
        asCharacter = "playing\n\(actorName)"
    }
    else
    {
        asCharacter = "as\nEnglish Dub"
    }
    
    return asCharacter
    
    }
    
    
    
    
    func sniffDictionary() -> String{
        var combineString = ""
        
        if let actorPic = newActorDictionary[thisMovie]?[actorName]?[1]
        {
            combineString = "https://image.tmdb.org/t/p/w500/\(actorPic)"
        }
        else
        {
            combineString = ""
        }
    
       
        return combineString
    }
}


