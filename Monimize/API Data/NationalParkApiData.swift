//
//  NationalParkApiData.swift
//  Monimize
//
//  Created by Ray Liu on 4/24/21.
//

import SwiftUI
import Foundation

/*let nationalParkActivityList = [ "Arts and Culture", "Astronomy", "Auto and ATV", "Biking" , "Boating", "Camping","Canyoneering", "Caving","Climbing", "Compass and GPS","Dog Sledding" ,"Fishing" ,"Flying" ,"Food" ,"Golfing" ,"Guided Tours" ,"Hands-On" ,"Hiking" ,"Horse Trekking" ,"Hunting and Gathering","Ice Skating" ,"Junior Ranger Program","Living History","Museum Exhibits","Paddling","Park Film" ,"Playground" ,"SCUBA Diving","Shopping","Skiing" ,"Snorkeling" ,"Snow Play" ,"Snowmobiling" ,"Snowshoeing" ,"Surfing" ,"Swimming" ,"Team Sports","Tubing" ,"Water Skiing","Wildlife Watching"]*/

/*
 var id: UUID
 var name: String
 var ticketPrice: String
 var latitude: Double
 var longitude: Double
 var description: String
 var website: String
 var state: String
 var contacts: String
 var parkImage: String
 */

var parkIDList = [String]()

var parkFound = Park(id: UUID(), name: "", ticketPrice: 0.0, latitude: 0.0, longitude: 0.0, description: "", website: "", state: "",  parkImage: "", parkType: "")


var parkResultsList = [Park]()


fileprivate var previousQuery = "",previousCategory = ""


public func cashInIDSearchList()
{
    //parkResultsList.removeAll()
    
    var temp = 60
    
    if (parkIDList.count < 60)
    {
        temp = parkIDList.count
    }
    
    let length = temp - 1

    let count = 0...length

    for number in count {
        
        obtainNationalParkDataFromApi(category: "ID" , query: parkIDList[number])
        
    }
    
    //parkIDList.removeAll()
    
}

 
/*
====================================
MARK: - Obtain Forecast Data from API
====================================
*/
public func obtainNationalParkDataFromApi(category: String, query: String) {
    
   
    if category == previousCategory && query == previousQuery {
        return
    } else {
        previousCategory = category
        previousQuery = query
    }
   
    // Initialization
    
    var parkFound = Park(id: UUID(), name: "", ticketPrice: 0.0, latitude: 0.0, longitude: 0.0, description: "", website: "", state: "", parkImage: "", parkType: "")
    
    let myApiKey = "KkO0cfCVZIF1uXbYUrEKxO9sE4jZFzomXh2lVTBv"
        
    /*
     *************************
     *   API Documentation   *
     *************************
 
     This API requires an Api key
     
     To search for park IDs based on activities:
     https://developer.nps.gov/api/v1/activities/parks?q=wildlife%20watching&limit=10&api_key=KkO0cfCVZIF1uXbYUrEKxO9sE4jZFzomXh2lVTBv
     
     To search for park details based on IDs:
     https://developer.nps.gov/api/v1/parks?parkCode=acad&api_key=KkO0cfCVZIF1uXbYUrEKxO9sE4jZFzomXh2lVTBv
     
     */
   
    /*
     *********************************************
     *   Obtaining API Search Query URL Struct   *
     *********************************************
     */
   
    // Replace space with UTF-8 encoding of space with %20
    let searchQuery = query.replacingOccurrences(of: " ", with: "%20")
   
    
    var apiUrl = ""
    
    switch category {
    case "Activity":
        apiUrl =
            "https://developer.nps.gov/api/v1/activities/parks?q=\(searchQuery)&limit=10&api_key=\(myApiKey)"
            
    case "ID":
        apiUrl =
            "https://developer.nps.gov/api/v1/parks?parkCode=\(searchQuery)&api_key=\(myApiKey)"
        
    default:
        fatalError("Search category is out of range!")
    }
    
    
            
   
    /*
     searchQuery may include unrecognizable foreign characters inputted by the user,
     e.g., Côte d'Ivoire, that can prevent the creation of a URL struct from the
     given apiUrl string. Therefore, we must test it as an Optional.
    */
    
   var apiQueryUrlStruct: NSURL?
   
    if let urlStruct = NSURL(string: apiUrl) {
        apiQueryUrlStruct = urlStruct
    } else {
        
        return
    }
 
    /*
    *******************************
    *   HTTP GET Request Set Up   *
    *******************************
    */
   
    let headers = [
        "accept": "application/json",
        "cache-control": "no-cache",
        "connection": "keep-alive",
        "host": "developer.nps.gov"
    ]
 
    let request = NSMutableURLRequest(url: apiQueryUrlStruct! as URL,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
 
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
 
    /*
    *********************************************************************
    *  Setting Up a URL Session to Fetch the JSON File from the API     *
    *  in an Asynchronous Manner and Processing the Received JSON File  *
    *********************************************************************
    */
   
    /*
     Create a semaphore to control getting and processing API data.
     signal() -> Int    Signals (increments) a semaphore.
     wait()             Waits for, or decrements, a semaphore.
     */
    let semaphore = DispatchSemaphore(value: 0)
 
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        /*
        URLSession is established and the JSON file from the API is set to be fetched
        in an asynchronous manner. After the file is fetched, data, response, error
        are returned as the input parameter values of this Completion Handler Closure.
        */
 
        // Process input parameter 'error'
        guard error == nil else {
            // countryFound will have the initial values set as above
            semaphore.signal()
            return
        }
       
        /*
         ---------------------------------------------------------
         🔴 Any 'return' used within the completionHandler Closure
            exits the Closure; not the public function it is in.
         ---------------------------------------------------------
         */
 
        // Process input parameter 'response'. HTTP response status codes from 200 to 299 indicate success.
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
           
            semaphore.signal()
            return
        }
 
        // Process input parameter 'data'. Unwrap Optional 'data' if it has a value.
        guard let jsonDataFromApi = data else {
           
            semaphore.signal()
            return
        }
        
 
        //------------------------------------------------
        // JSON data is obtained from the API. Process it.
        //------------------------------------------------
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,

                              options: JSONSerialization.ReadingOptions.mutableContainers)
            
            if (category == "Activity")
            {
                
                var jsonDataDictionary = Dictionary<String, Any>()

                if let jsonObject = jsonResponse as? [String: Any] {

                    jsonDataDictionary = jsonObject

                } else {
                    semaphore.signal()
                    return
                }
                
                var listJsonArray = [Any]()

                if let jArray = jsonDataDictionary["data"] as? [Any] {

                    listJsonArray = jArray

                } else {

                    semaphore.signal()
                    return
                }
                
                var singleDataJsonObject = [String: Any]()

                if let jObject = listJsonArray.first as? [String: Any] {

                    singleDataJsonObject = jObject

                } else {

                    semaphore.signal()

                    return

                }
                
               
                var parksJsonArray = [Any]()

                if let jArray = singleDataJsonObject["parks"] as? [Any] {

                    parksJsonArray = jArray

                } else {

                    semaphore.signal()
                    return
                }
                
                let length = parksJsonArray.count - 1

                let count = 0...length

                for number in count {
                    
                    var singleParkJsonObject = [String: Any]()

                    if let jObject = parksJsonArray[number] as? [String: Any] {

                        singleParkJsonObject = jObject

                    } else {

                        semaphore.signal()

                        return

                    }
                    
                    var parkID = ""
                    
                    if let IDPark = singleParkJsonObject["parkCode"] as? String {
                        
                        parkID = IDPark
                        
                    }
                    
                    parkIDList.append(parkID)
                    
                    
                }// end of for loop

            }
    
            else // category == "ID"
            {
                
                
                var jsonDataDictionary = Dictionary<String, Any>()

                if let jsonObject = jsonResponse as? [String: Any] {

                    jsonDataDictionary = jsonObject

                } else {
                    semaphore.signal()
                    return
                }
                
                var listJsonArray = [Any]()

                if let jArray = jsonDataDictionary["data"] as? [Any] {

                    listJsonArray = jArray

                } else {

                    semaphore.signal()
                    return
                }
                
                var singleDataJsonObject = [String: Any]()

                if let jObject = listJsonArray[0] as? [String: Any] {

                    singleDataJsonObject = jObject

                } else {

                    semaphore.signal()

                    return

                }
                /*
                var id: UUID
                var name: String
                var ticketPrice: String
                var latitude: Double
                var longitude: Double
                var description: String
                var website: String
                var state: String
                var contacts: String
                var parkImage: String
                var parkType: String*/
                
                var name = ""
                var ticketPrice = 0.0
                var latitude = 0.0
                var longitude = 0.0
                var description = ""
                var website = ""
                var state = ""
                var parkImage = ""
                var parkType = ""
                
                
                if let nameOfPark = singleDataJsonObject["fullName"] as? String {
                    
                    name = nameOfPark
                    
                }
                
                if let webOfPark = singleDataJsonObject["url"] as? String {
                    
                    website = webOfPark
                    
                }
                
                if let thisLatitude = singleDataJsonObject["latitude"] as? String {
                    
                    latitude = Double(thisLatitude)!
                    
                }
                
                if let thisLongitude = singleDataJsonObject["longitude"] as? String {
                    
                    longitude = Double(thisLongitude)!
                    
                }
                
                if let desOfPark = singleDataJsonObject["description"] as? String {
                    
                    description = desOfPark
                    
                }
                
                if let stateOfPark = singleDataJsonObject["states"] as? String {
                    
                    state = stateOfPark
                    
                }
                
                if let typeOfPark = singleDataJsonObject["designation"] as? String {
                    
                    parkType = typeOfPark
                    
                }
                
                if let imageArray = singleDataJsonObject["images"] as? [Any]
                {
                    
                    if let imageJsonObject = imageArray.first as? [String: Any]
                    {
                        
                        if let tempImage = imageJsonObject["url"] as? String {
                            
                            parkImage = tempImage
                            
                        }
                        
                    }
                
                }
                
                if let entraceFeesArray = singleDataJsonObject["entranceFees"] as? [Any]
                {
                    
                    if let feeJsonObject = entraceFeesArray.first as? [String: Any]
                    {
                        
                        if let tempCost = feeJsonObject["cost"] as? String {
                            
                            ticketPrice = Double(tempCost)!
                            
                        }
                        
                    }
                
                }
                
                
                let newID = UUID()
                
                parkFound = Park(id: newID, name: name, ticketPrice: ticketPrice, latitude: latitude, longitude: longitude, description: description, website: website, state: state, parkImage: parkImage, parkType: parkType)
                
                
                parkResultsList.append(parkFound)
            
            }// end of searching for id
            
            
          
        } catch {
           
            semaphore.signal()
            return
        }
 
        semaphore.signal()
    }).resume()
 
    /*
     The URLSession task above is set up. It begins in a suspended state.
     The resume() method starts processing the task in an execution thread.
 
     The semaphore.wait blocks the execution thread and starts waiting.
     Upon completion of the task, the Completion Handler code is executed.
     The waiting ends when .signal() fires or timeout period of 10 seconds expires.
    */
 
    _ = semaphore.wait(timeout: .now() + 10)
 
}
 

