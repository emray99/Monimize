//
//  CircleProgressBar.swift
//  Monimize
//
//  Created by Guo Yang on 4/26/21.
//

import SwiftUI

struct CirclerPercentProgressViewStyle: ProgressViewStyle {
    public func makeBody(configuration: LinearProgressViewStyle.Configuration) -> some View {
        VStack {
            configuration.label
                .foregroundColor(Color.secondary)
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 15.0)
                    .opacity(0.3)
                    .foregroundColor(Color.accentColor.opacity(0.5))
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(configuration.fractionCompleted ?? 0))
                    .stroke(style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.accentColor)
                
                Text("\(Int((configuration.fractionCompleted ?? 0) * 100)) %")
                    .font(.headline)
                    .foregroundColor(Color.secondary)
            }
        }
    }
}
