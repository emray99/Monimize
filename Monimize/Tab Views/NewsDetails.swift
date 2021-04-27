//
//  NewsDetails.swift
//  Monimize
//
//  Created by Ray Liu on 4/26/21.
//

import SwiftUI

struct NewsDetails: View {
   
    // Input Parameter
    let news: News
   
    var body: some View {
        // A Form cannot have more than 10 Sections.
        // Group the Sections if more than 10.
        Form {
            Group {
                Section(header: Text("NEWS TITLE")) {
                    Text(news.title)
                }
                Section(header: Text("REPORT IMAGE")){
                    getImageFromUrl(url: news.image , defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                        .padding()
                    
                }
                
                Section(header: Text("DESCRIPTION")) {
                    Text(news.description)
                }
                
                
                Section(header: Text("PUBLISHED TIME")) {
                    Text(news.time)
                }
                
                
                Section(header: Text("LANGUAGE")) {
                    Text(news.language)
                }
                
                Section(header: Text("READ NEWS HERE")) {

                    Link(destination: URL(string: news.website)!) {

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
        .navigationBarTitle(Text(news.title), displayMode: .inline)
            .font(.system(size: 14))
    
    
}


 
}
