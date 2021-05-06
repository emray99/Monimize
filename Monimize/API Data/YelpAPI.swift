//
//  YelpAPI.swift
//  Monimize
//
//  Created by Ray Liu on 5/4/21.
//

import SwiftUI
import Foundation

var restFound = Rest(id: UUID(), rating: 0.0, price: "", phone: "", name: "", website: "", image: "", longitude: 0.0, latitude: 0.0)


var restResultsList = [Rest]()


fileprivate var previousQuery = "",previousCategory = ""


public func obtainYelpDataFromApi(category: String, query: String) {
    
   
    if category == previousCategory && query == previousQuery {
        //return
        previousCategory = category
        previousQuery = query
    } else {
        previousCategory = category
        previousQuery = query
    }
   
    // Initialization
    
    var restFound = Rest(id: UUID(), rating: 0.0, price: "", phone: "", name: "", website: "", image: "", longitude: 0.0, latitude: 0.0)
    
    
    let myApiKey = "34w_zgQjejILCxIDpObrjDz62dyZ1mA2U2H321CYM0jZ4p-0K0Ixd3oZiKW2kHcVP2_WGFPQBtEIKc0Od0SUXxsSy6sNYQIM0BaTmNaIqmJrsf5fxaBORoFnB7qQYHYx"
    
    /*
     *************************
     *   API Documentation   *
     *************************
 
     This API requires an Api key
     
     https://api.yelp.com/v3/businesses/search?term=delis&latitude=37.786882&longitude=-122.399972
     
     */
   
    /*
     *********************************************
     *   Obtaining API Search Query URL Struct   *
     *********************************************
     */
   
    // Replace space with UTF-8 encoding of space with %20
    let searchQuery = query.replacingOccurrences(of: " ", with: "-")
   
    
    var apiUrl = ""
    
    let currentlat = currentLocation().latitude
    let currentlong = currentLocation().longitude
    
        apiUrl = "https://api.yelp.com/v3/businesses/search?term=\(searchQuery)&latitude=\(currentlat)&longitude=\(currentlong)&radius=\(2400)"
            

   
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
        "host": "api.yelp.com",
        "Authorization": "Bearer \(myApiKey)"
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
            
            
            var jsonDataDictionary = Dictionary<String, Any>()

            if let jsonObject = jsonResponse as? [String: Any] {

                jsonDataDictionary = jsonObject

            } else {
                semaphore.signal()
                return
            }
            
            var listJsonArray = [Any]()

            if let jArray = jsonDataDictionary["businesses"] as? [Any] {

                listJsonArray = jArray

            } else {

                semaphore.signal()
                return
            }
            
            let length = listJsonArray.count - 1
            
            if (length == -1)
            {
                semaphore.signal()
                return
            }
            
            
            let count = 0...length

            for number in count {
                
                var singleRestJsonObject = [String: Any]()

                if let jObject = listJsonArray[number] as? [String: Any] {

                    singleRestJsonObject = jObject

                } else {
                    semaphore.signal()
                    return
                }
                
                var rating = 0.0
                var price = ""
                var phone = ""
                var name = ""
                var website = ""
                var image = ""
                var longitude = 0.0
                var latitude = 0.0
                
                if let restRating = singleRestJsonObject["rating"] as? Double {
                    
                    rating = restRating
                    
                }
                
                if let restPrice = singleRestJsonObject["price"] as? String {
                    
                    price = restPrice
                    
                    if (price == "" || price == " ")
                    {
                        
                        price = "Unavailable"
                    }
                    
                }
                
                if let restPhone = singleRestJsonObject["phone"] as? String {
                    
                    phone = restPhone
                    
                }
                
                if let restName = singleRestJsonObject["name"] as? String {
                    
                    name = restName
                    
                }
                
                if let restUrl = singleRestJsonObject["url"] as? String {
                    
                    website = restUrl
                    
                }
                
                if let restImage = singleRestJsonObject["image_url"] as? String {
                    
                    image = restImage
                    
                }
                
                if let coordSet = singleRestJsonObject["coordinates"] as? [String: Any] {
                    
                    if let lat = coordSet["latitude"] as? Double {
                        
                        latitude = lat
                        
                    }
                    
                    if let long = coordSet["longitude"] as? Double {
                        
                        longitude = long
                        
                    }
                    
                    
                }
                
                
                let newID = UUID()
                
                restFound = Rest(id: newID, rating: rating, price: price, phone: phone, name: name, website: website, image: image, longitude: longitude, latitude: latitude)
                
               
                restResultsList.append(restFound)
             
                    
            } // end of all businesses
                
          
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
 

