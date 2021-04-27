//
//  Home.swift
//  Monimize
//
//  Created by Eric Li on 4/27/21.
//

import SwiftUI

struct Home: View {
    var body: some View {
        Image("pie-chart")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(minWidth: 300, maxWidth: 500, alignment: .center)
            .padding()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
