//
//  NewsList.swift
//  Monimize
//
//  Created by Ray Liu on 4/26/21.
//

import SwiftUI

struct NewsListPage: View {
    
    var body: some View {
        NavigationView {
            List {
                ForEach(newsList) { aNews in
                    
                    NavigationLink(destination: NewsDetails(news: aNews)) {

                        NewsItem(news: aNews)

                    }
                }
            }   // End of List
            .navigationBarTitle(Text("Latest News In English Language"), displayMode: .inline)
       
        .customNavigationViewStyle()      // Given in NavigationStyle.swift
        }
    }   // End of body
}
