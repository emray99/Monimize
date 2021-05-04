//
//  NewsApiData.swift
//  Monimize
//
//  Created by Ray Liu on 4/26/21.
//

import SwiftUI
import Foundation



fileprivate var previousQuery = ""

var newsList = [News]()

var newsFound = News(id: UUID(), title: "", author: "", language: "", time: "", website: "", description: "", category: "", image: "")


 
/*
====================================
MARK: - Obtain Forecast Data from API
====================================
*/
public func obtainNewsDataFromApi(query: String) {
    
    
    newsList.removeAll()
    
   
    // Avoid executing this function if already done for the same category and query
    if query == previousQuery {
        return
    } else {
        previousQuery = query
    }
   
    // Initialization

    let myApiKey = "96Ajr1ZNa5tl1x2IDZxBLcJGj0FQOmKqRFj9mycTT4_X40ci"
    
    /*
     *************************
     *   API Documentation   *
     *************************
 
     This API requires an Api key
     
     Example
     
     https://api.currentsapi.services/v1/latest-news?language=en&apiKey=96Ajr1ZNa5tl1x2IDZxBLcJGj0FQOmKqRFj9mycTT4_X40ci
    
     
     */
   
    /*
     *********************************************
     *   Obtaining API Search Query URL Struct   *
     *********************************************
     */
   
    // Replace space with UTF-8 encoding of space with %20
    let searchQuery = query.replacingOccurrences(of: " ", with: "%20")
   
    
    let apiUrl = "https://api.currentsapi.services/v1/latest-news?language=en&apiKey=96Ajr1ZNa5tl1x2IDZxBLcJGj0FQOmKqRFj9mycTT4_X40ci"
    
    
            
   
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
        "host": "api.currentsapi.services"
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

            if let jArray = jsonDataDictionary["news"] as? [Any] {

                listJsonArray = jArray

            } else {

                semaphore.signal()
                return
            }
            
            let length = listJsonArray.count - 1

            let count = 0...length

            for number in count {
                
                var singleNewsJsonObject = [String: Any]()

                if let jObject = listJsonArray[number] as? [String: Any] {

                    singleNewsJsonObject = jObject

                } else {

                    semaphore.signal()

                    return

                }
                /*
                public var id: UUID
                var title: String
                var author: String
                var language: String
                var time: String
                var website: String
                var description: String*/
                
                var title = ""
                var author = ""
                var language = ""
                var time = ""
                var website = ""
                var description = ""
                var category = ""
                var image = ""
                
            
                
                if let newsTitle = singleNewsJsonObject["title"] as? String {
                    
                    title = newsTitle
                    
                }
                
                if let newsAuthor = singleNewsJsonObject["author"] as? String {
                    
                    author = newsAuthor
                    
                }
                
                if let newsLanguate = singleNewsJsonObject["language"] as? String {
                    
                    language = newsLanguate
                    
                }
                
                if let newsTime = singleNewsJsonObject["published"] as? String {
                    
                    time = newsTime
                    
                }
                
                if let newsWebsite = singleNewsJsonObject["url"] as? String {
                    
                    website = newsWebsite
                    
                }
                
                if let newsDescription = singleNewsJsonObject["description"] as? String {
                    
                    description = newsDescription
                }
                
                if let newsCategory = singleNewsJsonObject["category"] as? [Any] {
                    
                    if (newsCategory.count == 0)
                    {
                        
                        category = "Undefined"
                    }
                    else
                    {
                        category = newsCategory.first as! String
                    }
                    
                }
                
                if let newsImage = singleNewsJsonObject["image"] as? String {
                    
                    image = newsImage
                }
                
                
                let newID = UUID()
                
                newsFound = News(id: newID, title: title, author: author, language: language, time: time, website: website, description: description, category: category, image: image)
                
                newsList.append(newsFound)
                
                
            }// end of for loop
            
    
           
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
 

