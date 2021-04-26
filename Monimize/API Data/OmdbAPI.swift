//
//  OmdbAPI.swift
//  Monimize
//
//  Created by Ray Liu on 4/25/21.
//


import SwiftUI
import Foundation


public var ImdbDictionary : [String : [String]] = ["IMDBID":["MovieTitle", "PG", "Genere", "Director" ,"Actors" ,"ImdbSCORE"]]


fileprivate var previousQuery = ""

 
/*
====================================
MARK: - Obtain Forecast Data from API
====================================
*/
public func obtainImdbDataFromApi(query: String) {
    
   
    // Avoid executing this function if already done for the same category and query
    if query == previousQuery {
        return
    } else {
        previousQuery = query
    }
   
    // Initialization

    let myApiKey = "9f67dd7a"
    
    /*
     *************************
     *   API Documentation   *
     *************************
 
     This API requires an Api key
     
     Example
     
     http://www.omdbapi.com/?apikey=9f67dd7a&i=tt3393786&plot=full&r=json
    
     
     */
   
    /*
     *********************************************
     *   Obtaining API Search Query URL Struct   *
     *********************************************
     */
   
    // Replace space with UTF-8 encoding of space with %20
    let searchQuery = query.replacingOccurrences(of: " ", with: "%20")
   
    
    let apiUrl =
    
    "https://www.omdbapi.com/?apikey=\(myApiKey)&i=\(searchQuery)&plot=full&r=json"
            
   
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
        "host": "www.omdbapi.com"
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
            
            var pgRating = ""
            var genre = ""
            var director = ""
            var actors = ""
            var imdbRating = ""
            var title = ""
            var imdbID = ""
            
            if let thisID = jsonDataDictionary["imdbID"] as? String {
                imdbID = thisID
            }
            
            if let movieTitle = jsonDataDictionary["Title"] as? String {
                title = movieTitle
            }
            
            
            if let ratedPG = jsonDataDictionary["Rated"] as? String {
                pgRating = ratedPG
            }
            
            if let movieGenre = jsonDataDictionary["Genre"] as? String {
                genre = movieGenre
            }
            
            if let movieDirector = jsonDataDictionary["Director"] as? String {
                director = movieDirector
            }
            
            if let movieActors = jsonDataDictionary["Actors"] as? String {
                actors = movieActors
            }
            
            if let ratedImdb = jsonDataDictionary["imdbRating"] as? String {
                imdbRating = ratedImdb
            }
            
            let imdbInfoHolder = [title,pgRating, genre, director, actors, imdbRating]
            
            ImdbDictionary[imdbID] = imdbInfoHolder
            
           
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
 

