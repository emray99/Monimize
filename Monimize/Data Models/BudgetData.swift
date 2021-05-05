//
//  BudgetData.swift
//  Monimize
//
//  Created by Eric Li on 4/27/21.
//

import SwiftUI
import Foundation
import AVFoundation
import CoreLocation

var budgetStructList = [BudgetStruct]()

var orderedSearchableBudgetList = [String]()
// Global Variable
var audioSession = AVAudioSession()

public func readBudgetDataFile() {
    var fileExistsInDocumentDirectory = false
    var documentDirectoryHasFiles = false
    let jsonDataFullFilename = "BudgetDataM.json"
    
    let urlOfJsonFileInDocumentDirectory = documentDirectory.appendingPathComponent(jsonDataFullFilename)
    
    do {
        _ = try Data(contentsOf: urlOfJsonFileInDocumentDirectory)
        
        // MultimediaNotesData.json file exists in the document directory
        documentDirectoryHasFiles = true
        
        budgetStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: jsonDataFullFilename, fileLocation: "Document Directory")
        print("BudgetData is loaded from document directory")
        
    } catch {
        
        documentDirectoryHasFiles = false
        budgetStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: jsonDataFullFilename, fileLocation: "Main Bundle")
        print("BudgetData is loaded from main bundle")
        
        for budget in budgetStructList {
            let selectedBudgetAttributesForSearch = "\(budget.id)|\(budget.title)|\(budget.note)|\(budget.category)|\(budget.date)"
           
            orderedSearchableBudgetList.append(selectedBudgetAttributesForSearch)
        }
    }
    
    if !fileExistsInDocumentDirectory {
        
        for budget in budgetStructList {
            
            // Example photo fullFilename = "D3C83FED-B482-425C-A3F8-6C90A636DFBF.jpg"
            let array = budget.photoFilename.components(separatedBy: ".")
            
            let array1 = budget.audioFilename.components(separatedBy: ".")
            
            // array[0] = "D3C83FED-B482-425C-A3F8-6C90A636DFBF"
            // array[1] = "jpg"
            
            // Copy each photo file from Assets.xcassets to document directory
            copyImageFileFromAssetsToDocumentDirectory(filename: array[0], fileExtension: array[1])
            copyFileFromMainBundleToDocumentDirectory(filename: array1[0], fileExtension: array1[1], folderName: "AudioFiles")
        }
    }
    
    if documentDirectoryHasFiles {
        // Obtain URL of the file in document directory on the user's device
        let urlOfFileInDocDir = documentDirectory.appendingPathComponent("OrderedSearchableBudgetList")
       
        // Instantiate an NSArray object and initialize it with the contents of the file
        let arrayFromFile: NSArray? = NSArray(contentsOf: urlOfFileInDocDir)
       
        if let arrayObtained = arrayFromFile {
            // Store the unique id of the created array into the global variable
            orderedSearchableBudgetList = arrayObtained as! [String]
        } else {
            print("OrderedSearchableBudgetList file is not found in document directory on the user's device!")
        }
    }
    
    
    
}

/*
 **********************************************************
 MARK: - Write Album Photos Data File to Document Directory
 **********************************************************
 */
public func writeBudgetsDataFile() {
    
    // Obtain URL of the JSON file into which data will be written
    let urlOfJsonFileInDocumentDirectory: URL? = documentDirectory.appendingPathComponent("BudgetDataM.json")
    
    // Encode photoStructList into JSON and write it into the JSON file
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(budgetStructList) {
        do {
            try encoded.write(to: urlOfJsonFileInDocumentDirectory!)
        } catch {
            fatalError("Unable to write encoded budget data to document directory!")
        }
    } else {
        fatalError("Unable to encode budget data!")
    }
    
    let urlOfFileInDocDirectory = documentDirectory.appendingPathComponent("OrderedSearchableBudgetList")
    (orderedSearchableBudgetList as NSArray).write(to: urlOfFileInDocDirectory, atomically: true)
}

/*
 **************************************************************
 MARK: - Save Taken or Picked Photo Image to Document Directory
 **************************************************************
 */
//public func saveNote(title: String, textualNote: String, speechToTextNote: String, locationName: String) -> Notes {
//
//    //----------------------------------------
//    // Generate a new id and new full filename
//    //----------------------------------------
//    let newNoteId = UUID()
//    let newPhotoFullFilename = UUID().uuidString + ".jpg"
//    let newAudioFullFilename = UUID().uuidString + ".m4a"
//
//    //-----------------------------
//    // Obtain Current Date and Time
//    //-----------------------------
//    let date = Date()
//
//    // Instantiate a DateFormatter object
//    let dateFormatter = DateFormatter()
//
//    // Set the date format to yyyy-MM-dd at HH:mm:ss
//    dateFormatter.dateFormat = "yyyy-MM-dd' at 'HH:mm:ss"
//
//    // Format current date and time as above and convert it to String
//    let currentDateTime = dateFormatter.string(from: date)
//
//    //----------------------------------------------------------
//    // Get Latitude and Longitude of Where Photo Taken or Picked
//    //----------------------------------------------------------
//
//    // Public function currentLocation() is given in CurrentLocation.swift
//    let noteLocation = currentLocation()
//
//    let newNote = Notes(id: newNoteId, title: title, textualNote: textualNote,
//                        photoFullFilename: newPhotoFullFilename,
//                        audioFullFilename: newAudioFullFilename,
//                        speechToTextNote: speechToTextNote,
//                        locationName: locationName,
//                        dateTime: currentDateTime, latitude:noteLocation.latitude , longitude:noteLocation.longitude)
//
//    //-------------------------------------------------------
//    // Save Taken or Picked Photo Image to Document Directory
//    //-------------------------------------------------------
//
//    // Global variable pickedImage was obtained in ImagePicker.swift
//
//    /*
//     Convert pickedImage to a data object containing the
//     image data in JPEG format with 100% compression quality
//     */
//    if let data = pickedImage.jpegData(compressionQuality: 1.0) {
//        let fileUrl = documentDirectory.appendingPathComponent(newPhotoFullFilename)
//        try? data.write(to: fileUrl)
//    } else {
//        print("Unable to write photo image to document directory!")
//    }
//
//    return newNote
//}


/*
 ******************************************
 MARK: - Get Permission for Voice Recording
 ******************************************
 */
public func getPermissionForVoiceRecording() {
    
    // Create a shared audio session instance
    audioSession = AVAudioSession.sharedInstance()
    
    //---------------------------
    // Enable Built-In Microphone
    //---------------------------
    
    // Find the built-in microphone.
    guard let availableInputs = audioSession.availableInputs,
          let builtInMicrophone = availableInputs.first(where: { $0.portType == .builtInMic })
    else {
        print("The device must have a built-in microphone.")
        return
    }
    do {
        try audioSession.setPreferredInput(builtInMicrophone)
    } catch {
        print("Unable to Find the Built-In Microphone!")
    }
    
    //--------------------------------------------------
    // Set Audio Session Category and Request Permission
    //--------------------------------------------------
    
    do {
        try audioSession.setCategory(.playAndRecord, mode: .default)
        
        // Activate the audio session
        try audioSession.setActive(true)
        
        // Request permission to record user's voice
        audioSession.requestRecordPermission() { allowed in
            DispatchQueue.main.async {
                if allowed {
                    // Permission is recorded in the Settings app on user's device
                } else {
                    // Permission is recorded in the Settings app on user's device
                }
            }
        }
    } catch {
        print("Setting category or getting permission failed!")
    }
}




