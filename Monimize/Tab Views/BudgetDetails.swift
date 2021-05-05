//
//  BudgetDetails.swift
//  Monimize
//
//  Created by Eric Li on 4/27/21.
//

import SwiftUI
import MapKit
import AVFoundation

struct BudgetDetails: View {
    let budget: BudgetStruct

    @EnvironmentObject var userData: UserData
    @EnvironmentObject var audioPlayer: AudioPlayer
    var body: some View {
        Form {
            Section(header: Text("Budget Title")) {
                Text(budget.title)
            }
            if budget.photoFilename != "" {
                Section(header: Text("Budget Photo")) {
                    // This public function is given in UtilityFunctions.swift
                    getImageFromDocumentDirectory(filename: budget.photoFilename.components(separatedBy: ".")[0], fileExtension: budget.photoFilename.components(separatedBy: ".")[1], defaultFilename: "DefaultTripPhoto")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 300, maxWidth: 500, alignment: .center)
     
                }
            }
           
            
            Section(header: Text("Budget Amount")) {
                budgetAmount
            }
            
            Section(header: Text("Budget Category")) {
                HStack {
                    Image(budget.category)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20.0)
                    
                    Text(budget.category)
                }
                
            }
            
            Section(header: Text("Textual Note")) {
                Text(budget.note)
            }
            
            Section(header: Text("Show Expanse Location On Map")) {
                NavigationLink(destination: noteLocationOnMap) {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)
                        Text("Show Photo Location on Map")
                            .font(.system(size: 16))
                    }
                    .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
                }
            }
            
            Section(header: Text("PLAY NOTES TAKEN BY VOICE RECORDING")) {
                Button(action: {
                    if self.audioPlayer.isPlaying {
                        self.audioPlayer.pauseAudioPlayer()
                    } else {
                        self.audioPlayer.startAudioPlayer()
                    }
                }) {
                    HStack{
                    Image(systemName: self.audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                        .foregroundColor(.blue)
                        .font(Font.title.weight(.regular))
                    Text("Voice Notes")
                    }
                }
                    
            }
        } // End of Form
        .navigationBarTitle(Text("Budget Details"), displayMode: .inline)
        .font(.system(size: 14))
    }
    var budgetAmount: Text {
           let amount = budget.amount
          
           // Add thousand separators to trip cost
           let numberFormatter = NumberFormatter()
           numberFormatter.numberStyle = .decimal
           numberFormatter.usesGroupingSeparator = true
           numberFormatter.groupingSize = 3
          
           let bAmount = "$" + numberFormatter.string(from: amount as NSNumber)!
           return Text(bAmount)
       }
    
    var noteLocationOnMap: some View {
        return AnyView(MapView(mapType: MKMapType.standard, latitude: budget.latitude,
                               longitude: budget.longitude, delta: 15.0, deltaUnit: "degrees",
                               annotationTitle: budget.title, annotationSubtitle: budget.date)
            .navigationBarTitle(Text(budget.title), displayMode: .inline)
            .edgesIgnoringSafeArea(.all) )
    }
    
    func createPlayer() {
        let voiceMemoFileUrl = documentDirectory.appendingPathComponent(budget.audioFilename)
        audioPlayer.createAudioPlayer(url: voiceMemoFileUrl)
    }
}

