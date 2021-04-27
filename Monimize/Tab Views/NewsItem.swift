//
//  NewsItem.swift
//  Monimize
//
//  Created by Ray Liu on 4/26/21.
//

import SwiftUI

struct NewsItem: View {
    // Input Parameter
    let news: News
   
    var body: some View {
        HStack {
            // Public function getImageFromUrl is given in UtilityFunctions.swift
            getImageFromUrl(url: news.image, defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
           
            VStack(alignment: .leading) {
                Text("Title: \(news.title)")
                Text("Autor: \(news.author)")
                Text("Category: \(news.category)")
                
                
            }
            .font(.system(size: 14))
           
        }   // End of HStack
    }
}
 


