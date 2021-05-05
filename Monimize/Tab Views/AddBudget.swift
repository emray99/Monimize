//
//  AddBudget.swift
//  Monimize
//
//  Created by Eric Li on 4/27/21.
//

import SwiftUI

import AVFoundation
import Foundation
import CoreLocation

fileprivate var audioFullFilename = ""
fileprivate var audioRecorder: AVAudioRecorder!

struct AddBudget: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.presentationMode) var presentationMode

    @State private var title = ""
    @State private var note = ""
    @State private var value = 0.0
    @State private var showImagePicker = false
    @State private var recordingVoice = false
    @State private var showCurrencyPicker = false
    @State private var showBudgetAddedAlert = false
    @State private var showInputDataMissingAlert = false
    @State private var photoImageData: Data? = nil
    @State private var photoTakeOrPickIndex = 1
    let currencyList = ["USD", "AUD", "CAD", "EUR", "GBP", "JPY"]
    let currencyDict = ["USD": "$", "AUD": "A$", "CAD": "C$", "EUR": "€", "GBP": "£", "JPY": "¥"]
    let categoryList = ["Automobile", "Bills", "Grocery", "Clothing", "Digital", "Education", "Fees", "Food & Dining" , "Health Care", "Housing", "Leisure", "Loans", "Other"]
    @State private var categoryIndex = 0
    var photoTakeOrPickChoices = ["Camera", "Photo Library"]
    @State private var selectedIndex = 0  // Brandy
    
    let moneyFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSize = 3
        return numberFormatter
    }()
    var body: some View {
        Form {
            Section(header: Text("Describe your budget"), footer:
                        Button(action: {
                            self.dismissKeyboard()

                        }) {
                            Image(systemName: "keyboard")
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }) {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "textbox")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 24, weight: .regular))
                        TextField("Name", text: $title)
                            .disableAutocorrection(true)
                            .autocapitalization(.words)
                            .padding(8)
                    }
                    .frame(height: 50)
                    Divider()
                    HStack {
                        Image(systemName: "plusminus.circle")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 26, weight: .regular))
                        TextField("Amount", value: $value, formatter: moneyFormatter)
                            .keyboardType(.numbersAndPunctuation)
    
                        
                        Button(action: {
                            self.showCurrencyPicker = true
                        }) {
                            Text(currencyList[selectedIndex])
                                .foregroundColor(Color.gray)
                        }
                        .sheet(isPresented: self.$showCurrencyPicker) {
                            Picker("", selection: $selectedIndex){
                                ForEach(0 ..< currencyList.count, id: \.self) {
                                    Text(currencyList[$0])
                                        .font(.system(size: 26))
                                }
                            }
                            //.frame(minWidth: 300, maxWidth: 500, alignment: .leading)
                        }
                        
                    }
                    .frame(height: 40)
                    Divider()
                    HStack{
                        Image(systemName: "note.text.badge.plus")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 26, weight: .regular))
                        Text("Add Note for this budget")
                            .foregroundColor(Color.gray)
                    }
                    TextEditor(text: $note)
                        .frame(height: 100)
                        .font(.custom("Helvetica", size: 14))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                }
            }
            .alert(isPresented: $showBudgetAddedAlert, content: { self.budgetAddedAlert })
            Section(header: Text("Picture for this budget")){
                Picker("Select Photo Type", selection: $photoTakeOrPickIndex) {
                    ForEach(0 ..< photoTakeOrPickChoices.count, id: \.self) { index in
                       Text(self.photoTakeOrPickChoices[index]).tag(index)
                   }
                }
                .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                .pickerStyle(SegmentedPickerStyle())
                //.padding(.horizontal)
                
                if photoTakeOrPickIndex == 0 {
                    Button(action: {
                        self.showImagePicker = true
                    }) {
                        Text("Get Photo")
                            .padding(.horizontal, 110)
                        
                    }
                    .sheet(isPresented: self.$showImagePicker) {
                        PhotoCaptureView(showImagePicker: self.$showImagePicker,
                                         photoImageData: self.$photoImageData,
                                         cameraOrLibrary: "Camera")
                }

                } else {
                    Button(action: {
                        self.showImagePicker = true
                    }) {
                        Text("Get Photo")
                            .padding(.horizontal, 110)
                    }
                    .sheet(isPresented: self.$showImagePicker) {
                        PhotoCaptureView(showImagePicker: self.$showImagePicker,
                                         photoImageData: self.$photoImageData,
                                         cameraOrLibrary: "Photo Library")
                    }
                }
                
            }
            
            Section(header: Text("Picked Photo"))
            {
                if (photoImageData == nil)
                {
                    Image("DefaultMultimediaNotePhoto")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100.0)
                    
                }
                else
                {
                    getImageFromBinaryData(binaryData: self.photoImageData, defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100.0)
                }
                
            }
            
            Section(header: Text("Choose a category for this budget")) {
                Picker("", selection: $categoryIndex) {
                    ForEach(0 ..< categoryList.count, id: \.self) {
                        Text(self.categoryList[$0])
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
            }
            
            Section(header: Text("Voice Recording")) {
                Button(action: {
                    self.voiceRecordingMicrophoneTapped()
                }) {
                    voiceRecordingMicrophoneLabel
                }
            }
            
        } // End of Form
        .alert(isPresented: $showInputDataMissingAlert, content: { self.inputDataMissingAlert })
        .navigationBarTitle(Text("Add New Expense"), displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                if self.inputDataValidated() {
                    self.addNewBudget()
                    self.showBudgetAddedAlert = true
                } else {
                    self.showInputDataMissingAlert = true
                }
            }) {
                Text("Save")
            })
        .font(.system(size: 14))
        
    }
    var budgetAddedAlert: Alert {
        Alert(title: Text("Expense Added!"),
              message: Text("New expense is added to the list."),
              dismissButton: .default(Text("OK")){
                // Dismiss this Modal View and go back to the previous view in the navigation hierarchy
                self.presentationMode.wrappedValue.dismiss()
              } )
    }
    var inputDataMissingAlert: Alert {
        Alert(title: Text("Missing Input Data!"),
              message: Text("Required Data: Title, Amount."),
              dismissButton: .default(Text("OK")) )
    }
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    func inputDataValidated() -> Bool {
       
        if self.title.isEmpty || self.value == 0 {
            return false
        }
       
        return true
    }
    
   
   
    
    var voiceRecordingMicrophoneLabel: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: recordingVoice ? "mic.fill" : "mic.slash.fill")
                    .imageScale(.large)
                    .font(Font.title.weight(.medium))
                    .foregroundColor(.blue)
                    .padding()
                Text(recordingVoice ? "Recording your voice... Tap to Stop!" : "Start Recording!")
                    .multilineTextAlignment(.center)
                Spacer()
            }
            
        }
    }
    
    func voiceRecordingMicrophoneTapped() {
        if audioRecorder == nil {
            self.recordingVoice = true
            //userData.startDurationTimer()
            startRecording()
        } else {
            self.recordingVoice = false
            //userData.stopDurationTimer()
            finishRecording()
        }
    }
    
    func startRecording() {
 
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
       
        audioFullFilename = UUID().uuidString + ".m4a"
        let audioFilenameUrl = documentDirectory.appendingPathComponent(audioFullFilename)
       
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilenameUrl, settings: settings)
            audioRecorder.record()
        } catch {
            finishRecording()
        }
    }
    
    func finishRecording() {
        audioRecorder.stop()
        audioRecorder = nil
        self.recordingVoice = false
    }
    
    func addNewBudget() {
        let date = Date()
        let bid = UUID()
        let currdateFormatter = DateFormatter()
        currdateFormatter.dateFormat = "yyyy-MM-dd' at 'HH:mm:ss"
        let currentDateTime = currdateFormatter.string(from: date)
        let newPhotoName = UUID().uuidString + ".jpg"
        
       
        
       
        let currentGeolocation = currentLocation()
        if let data = pickedImage.jpegData(compressionQuality: 1.0) {
            let fileUrl = documentDirectory.appendingPathComponent(newPhotoName)
            try? data.write(to: fileUrl)
            
        } else {
            print("Unable to write photo image to document directory!")
        }
        let newBudget = BudgetStruct(id: bid, title: self.title, currency: self.currencyList[selectedIndex], amount: self.value, note: self.note, category: self.categoryList[categoryIndex], audioFilename: audioFullFilename, date: currentDateTime, photoFilename: newPhotoName, latitude: currentGeolocation.latitude, longitude: currentGeolocation.longitude)
        let selectedBudgetAttributesForSearch = "\(bid)|\(title)|\(note)|\(categoryList[categoryIndex])|\(currentDateTime)"
        userData.budgetsList.append(newBudget)
        budgetStructList = userData.budgetsList
        userData.searchableOrderedBudgetsList.append(selectedBudgetAttributesForSearch)
        orderedSearchableBudgetList = userData.searchableOrderedBudgetsList
        audioFullFilename = ""
        self.photoImageData = nil
        userData.voiceRecordingDuration = ""
        self.presentationMode.wrappedValue.dismiss()

        
     
        
    }
}

