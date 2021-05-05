//
//  UserData.swift
//  Monimize
//
//  Created by Ray Liu on 4/20/21.
//

import SwiftUI
import Combine

final class UserData: ObservableObject {
  
    // ❎ Subscribe to notification that the managedObjectContext completed a save
    @Published var savedInDatabase =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    //var userAuthenticated = true
    @Published var userAuthenticated = false
    @Published var passwordResetting = false
    
    
    // Instance Variables for Voice Recording Duration Timer
    var durationTimer = Timer()
    var startTime: Double = 0
    var timeElapsed: Double = 0
    var timerHours: UInt8 = 0
    var timerMinutes: UInt8 = 0
    var timerSeconds: UInt8 = 0
    var timerMilliseconds: UInt8 = 0
    
    // Publish voiceRecordingDuration
    @Published var voiceRecordingDuration = ""
    
    /*
     ---------------------------------------------------
     MARK: - Scheduling a Voice Recording Duration Timer
     ---------------------------------------------------
     */
    public func startDurationTimer() {
        /*
         Schedule a timer to invoke the updateTimeLabel() function given below
         after 0.01 second in a loop that repeats itself until it is stopped.
         */
        durationTimer = Timer.scheduledTimer(timeInterval: 0.01,
                                             target: self,
                                             selector: (#selector(self.updateTimeLabel)),
                                             userInfo: nil,
                                             repeats: true)
       
        // Time at which the timer starts
        startTime = Date().timeIntervalSinceReferenceDate
    }
   
    public func stopDurationTimer() {
        durationTimer.invalidate()
    }
    
    @objc func updateTimeLabel(){
        // Calculate total time since timer started in seconds
        timeElapsed = Date().timeIntervalSinceReferenceDate - startTime
       
        // Calculate hours
        timerHours = UInt8(timeElapsed / 3600)
        timeElapsed = timeElapsed - (TimeInterval(timerHours) * 3600)
       
        // Calculate minutes
        timerMinutes = UInt8(timeElapsed / 60.0)
        timeElapsed = timeElapsed - (TimeInterval(timerMinutes) * 60)
       
        // Calculate seconds
        timerSeconds = UInt8(timeElapsed)
        timeElapsed = timeElapsed - TimeInterval(timerSeconds)
       
        // Calculate milliseconds
        timerMilliseconds = UInt8(timeElapsed * 100)
       
        // Create the time string and update the label
        let timeString = String(format: "%02d:%02d:%02d.%02d", timerHours, timerMinutes, timerSeconds, timerMilliseconds)
        voiceRecordingDuration = timeString
    }
   
    @Published var budgetsList = budgetStructList
    
    @Published var searchableOrderedBudgetsList = orderedSearchableBudgetList

   
   
 
}
 
