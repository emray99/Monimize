//
//  TmdbAPI.swift
//  Monimize
//
//  Created by Ray Liu on 4/25/21.
//


import SwiftUI
import Foundation

/*public var id: UUID
var title: String
var posterFileName: String
var overview: String
var genres: String
var releaseDate: String
var runtime: Int
var director: String
var actors: String
var mpaaRating: String
var imdbRating: String
var youTubeTrailerId: String
var tmdbID: Int*/


var movieFound = Movie(id: UUID(), title: "", posterFileName: "", overview: "", genres: "", releaseDate: "", runtime: 0, director: "", actors: "", mpaaRating: "", imdbRating: "", youTubeTrailerId: "", tmdbID: 0)

var recentMovieList = [Movie]()
var searchResultList = [Movie]()

var movieIDSearchList = [String]()

public var actorDictionary : [String : [String]] = ["Dummy Character":["Dummy Actor", "Dummy Image"]]

public var newActorDictionary : [String : [String : [String]]] = ["Bad Movie": ["Bad Actor" : ["Bad Char", "Char Image"]]]

var actorsInMovie = [String : [String]]() // = ["Bad Movie" : ["Bad Actor1", "Bad Actor2"]]

var tempTmdbCollection = [[Any]]()


fileprivate var previousQuery = "", previousCategory = ""


public func cashInIDSearchList(category: String){

    let cate = "ID"
    
    var length = movieIDSearchList.count - 1
    var count = 0...length
    var idToBeSearched = ""
    for number in count {
        idToBeSearched = movieIDSearchList[number]
        obtainTmdbDataFromApi(category: cate, query: idToBeSearched)
    }
    
    length = tempTmdbCollection.count - 1
    if (length == -1)
    {
        return
    }
    count = 0...length
    var imdbToBeSearched = ""
    for number in count {
        imdbToBeSearched = tempTmdbCollection[number][7] as! String
        obtainImdbDataFromApi(query: imdbToBeSearched)
    }
    
    var title = ""
    var posterFileName = ""
    var overview = ""
    var releaseDate = ""
    var runtime = 0
    var youTubeTrailerId = ""
    var tmdbID = 0
    
    
    var imdbID = ""
//These come from the imdb api dictionary
    var genres = ""
    var actors = ""
    var director = ""
    var mpaaRating = ""
    var imdbRating = ""
    
    length = tempTmdbCollection.count - 1
    count = 0...length
    
    var movieFound = Movie(id: UUID(), title: "", posterFileName: "", overview: "", genres: "", releaseDate: "", runtime: 0, director: "", actors: "", mpaaRating: "", imdbRating: "", youTubeTrailerId: "", tmdbID: 0)
    
    var imdbKey = ""
    
    if (category == "Recent")
    {
        for number in count {
            imdbKey = tempTmdbCollection[number][7] as! String
            
            title = tempTmdbCollection[number][0] as! String
            posterFileName = tempTmdbCollection[number][1] as! String
            overview = tempTmdbCollection[number][2] as! String
            releaseDate = tempTmdbCollection[number][3] as! String
            runtime = tempTmdbCollection[number][4] as! Int
            youTubeTrailerId = tempTmdbCollection[number][5] as! String
            tmdbID = tempTmdbCollection[number][6] as! Int
            
            genres = ImdbDictionary[imdbKey]![2]
            actors = ImdbDictionary[imdbKey]![4]
            director = ImdbDictionary[imdbKey]![3]
            mpaaRating = ImdbDictionary[imdbKey]![1]
            imdbRating = ImdbDictionary[imdbKey]![5]
            
            var newID = UUID()
           
            movieFound = Movie(id: newID, title: title, posterFileName: posterFileName, overview: overview, genres: genres, releaseDate: releaseDate, runtime: runtime, director: director, actors: actors, mpaaRating: mpaaRating, imdbRating: imdbRating, youTubeTrailerId: youTubeTrailerId, tmdbID: tmdbID)
            
            recentMovieList.append(movieFound)
        }
        
    }
    else
    {
        for number in count {
            imdbKey = tempTmdbCollection[number][7] as! String
            
            title = tempTmdbCollection[number][0] as! String
            posterFileName = tempTmdbCollection[number][1] as! String
            overview = tempTmdbCollection[number][2] as! String
            releaseDate = tempTmdbCollection[number][3] as! String
            runtime = tempTmdbCollection[number][4] as! Int
            youTubeTrailerId = tempTmdbCollection[number][5] as! String
            tmdbID = tempTmdbCollection[number][6] as! Int
            
            genres = ImdbDictionary[imdbKey]![2]
            actors = ImdbDictionary[imdbKey]![4]
            director = ImdbDictionary[imdbKey]![3]
            mpaaRating = ImdbDictionary[imdbKey]![1]
            imdbRating = ImdbDictionary[imdbKey]![5]
            
            var newID = UUID()
           
            movieFound = Movie(id: newID, title: title, posterFileName: posterFileName, overview: overview, genres: genres, releaseDate: releaseDate, runtime: runtime, director: director, actors: actors, mpaaRating: mpaaRating, imdbRating: imdbRating, youTubeTrailerId: youTubeTrailerId, tmdbID: tmdbID)
            
            searchResultList.append(movieFound)
        }
    }
    
}



 
/*
====================================
MARK: - Obtain Forecast Data from API
====================================
*/
public func obtainTmdbDataFromApi(category: String, query: String) {
    
   
    if category == previousCategory && query == previousQuery {
        return
    } else {
        previousCategory = category
        previousQuery = query
    }
   
    // Initialization
    
    var movieFound = Movie(id: UUID(), title: "", posterFileName: "", overview: "", genres: "", releaseDate: "", runtime: 0, director: "", actors: "", mpaaRating: "", imdbRating: "", youTubeTrailerId: "", tmdbID: 0)
    
    let myApiKey = "f6b16598bc7e16647b33da1e07b97907"

    
    /*
     *************************
     *   API Documentation   *
     *************************
 
     This API requires an Api key
     
     TO SEARCH FOR RECENT MOVIES (CAN OBTAIN MOVIE ID) dummy query
     https://api.themoviedb.org/3/movie/now_playing?api_key=YOUR-API-KEY
     
     TO SEARCH FOR A SPECIFIC MOVIE NAME (CAN OBTAIN MOVIE ID) movie name query
     http://api.themoviedb.org/3/search/movie?api_key=YOUR-API-KEY&query=Jack+Reacher
     
     TO SEARCH FOR MULTIPLE NONESENSE AT THE SAME TIME (REQUIRE MOVIE ID) movie id query
     https://api.themoviedb.org/3/movie/343611?api_key=YOUR-API-KEY&append_to_response=credits,videos
     
     */
   
    /*
     *********************************************
     *   Obtaining API Search Query URL Struct   *
     *********************************************
     */
   
    // Replace space with UTF-8 encoding of space with %20
    let searchQuery = query.replacingOccurrences(of: " ", with: "+")
   
    
    var apiUrl = ""
    
    switch category {
    case "Recent":
        apiUrl =
            "https://api.themoviedb.org/3/movie/now_playing?api_key=\(myApiKey)"
            
    case "Name":
        apiUrl =
            "https://api.themoviedb.org/3/search/movie?api_key=\(myApiKey)&query=\(searchQuery)"
        
    case "ID":
        apiUrl =
            "https://api.themoviedb.org/3/movie/\(searchQuery)?api_key=\(myApiKey)&append_to_response=credits,videos"
        
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
        "host": "api.themoviedb.org"
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
            
            if (category == "Recent")
            {
                
                var jsonDataDictionary = Dictionary<String, Any>()

                if let jsonObject = jsonResponse as? [String: Any] {

                    jsonDataDictionary = jsonObject

                } else {
                    semaphore.signal()
                    return
                }
                
                var listJsonArray = [Any]()
                
                if let jArray = jsonDataDictionary["results"] as? [Any] {

                    listJsonArray = jArray

                } else {

                    semaphore.signal()
                    return
                }
                
                
                let length = 8
                let count = 0...length
                for number in count {
                    
                    var singleMovieJsonObject = [String: Any]()

                    if let jObject = listJsonArray[number] as? [String: Any] {

                        singleMovieJsonObject = jObject

                    } else {

                        semaphore.signal()

                        return

                    }
                    
                    var aMovieID = ""
                    
                    
                    if let movieID = singleMovieJsonObject["id"] as? Int {
                          aMovieID = String(movieID)
                    }
                    
                    movieIDSearchList.append(aMovieID)
                    
                    
                }// end of for loop, have 9 recent movie IDs now.

    
            }
            else if (category == "Name")
            {
                var jsonDataDictionary = Dictionary<String, Any>()

                if let jsonObject = jsonResponse as? [String: Any] {

                    jsonDataDictionary = jsonObject

                } else {
                    semaphore.signal()
                    return
                }
                
                var listJsonArray = [Any]()
                
                if let jArray = jsonDataDictionary["results"] as? [Any] {

                    listJsonArray = jArray

                } else {

                    semaphore.signal()
                    return
                }
                
                if (!listJsonArray.isEmpty)
                {
                    let length = listJsonArray.count - 1
                    let count = 0...length
                    for number in count {
                        
                        var singleMovieJsonObject = [String: Any]()

                        if let jObject = listJsonArray[number] as? [String: Any] {

                            singleMovieJsonObject = jObject

                        } else {

                            semaphore.signal()

                            return

                        }
                        
                        var aMovieID = ""
                        
                        
                        if let movieID = singleMovieJsonObject["id"] as? Int {
                              aMovieID = String(movieID)
                        }
                        
                        movieIDSearchList.append(aMovieID)
                        
                        
                    }// end of for loop, have 9 recent movie IDs now.
                    
                }
                else
                {
                    semaphore.signal()
                    return
                }
            
                
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
                
                var title = ""
                var posterFileName = ""
                var overview = ""
                var releaseDate = ""
                var runtime = 0
                var youTubeTrailerId = ""
                var tmdbID = 0
                
                
                var imdbID = ""
//These come from the imdb api dictionary
                var genres = ""
                var actors = ""
                var director = ""
                var mpaaRating = ""
                var imdbRating = ""

                
                if let movieTitle = jsonDataDictionary["original_title"] as? String {
                    title = movieTitle
                }
                
                if let moviePoster = jsonDataDictionary["poster_path"] as? String {
                    posterFileName = moviePoster
                }
                
                if let movieOverview = jsonDataDictionary["overview"] as? String {
                    overview = movieOverview
                }
                
                if let movieRelease = jsonDataDictionary["release_date"] as? String {
                    releaseDate = movieRelease
                }
                
                if let movieRuntime = jsonDataDictionary["runtime"] as? Int {
                    runtime = movieRuntime
                }
                
                if let movieTmdbID = jsonDataDictionary["id"] as? Int {
                     tmdbID = movieTmdbID
                }
                
                if let youtubeJsonObject = jsonDataDictionary["videos"] as? [String: Any]
                {
                    
                    var listJsonArray = [Any]()
                    
                    if let jArray = youtubeJsonObject["results"] as? [Any] {

                        listJsonArray = jArray

                    } else {

                        semaphore.signal()
                        return
                    }
                    
                    if (!listJsonArray.isEmpty)
                    {
                        var singleVideoJsonObject = [String: Any]()
                        if let jObject = listJsonArray[0] as? [String: Any] {

                            singleVideoJsonObject = jObject

                        } else {

                            semaphore.signal()

                            return

                        }
                        
                        if let videoID = singleVideoJsonObject["key"] as? String {
                              youTubeTrailerId = videoID
                        }
                        
                        
                    }
                    else
                    {
                        semaphore.signal()
                        return
                    }
                   
                    
                    
                } // end of dealing with youtube
                
                
                if let creditsJsonObject = jsonDataDictionary["credits"] as? [String: Any]
                {
                    var listJsonArray = [Any]()
                    
                    if let jArray = creditsJsonObject["cast"] as? [Any] {

                        listJsonArray = jArray

                    } else {

                        semaphore.signal()
                        return
                    }
                    
                    newActorDictionary[title] = ["Temp" : ["Temp1", "Temp2"]]
                    
                    if (listJsonArray.isEmpty)
                    {
                        semaphore.signal()
                        return
                    }
                    
                    var actorList = [String]()
                    
                    let length = listJsonArray.count - 1
                    let count = 0...length
                    for number in count {
                        
                        var singleCharacterJsonObject = [String: Any]()

                        if let jObject = listJsonArray[number] as? [String: Any] {

                            singleCharacterJsonObject = jObject

                        } else {

                            semaphore.signal()

                            return

                        }
                        
                        var characterName = ""
                        var characterActor = ""
                        var ActorPic = ""
                        
                        
                        if let nameOfChar = singleCharacterJsonObject["character"] as? String {
                              characterName = nameOfChar
                        }
                        
                        if let charActor = singleCharacterJsonObject["name"] as? String {
                              characterActor = charActor
                        }
                        
                        if let picPath = singleCharacterJsonObject["profile_path"] as? String {
                              ActorPic = picPath
                        }
                        
                        
                        /*newActorDictionary : [String : [String : [String]]] = ["Bad Movie": ["Bad Actor" : ["Bad Char", "Char Image"]]]*/
                        
                        actorList.append(characterActor)
                        
                        let thisMovieDictionary = [characterName, ActorPic]
                        newActorDictionary[title]![characterActor] = thisMovieDictionary
                        
                        let charHolder = [characterActor, ActorPic]
                        actorDictionary[characterName] = charHolder
                        
                        
                    }// end of for loop, paired all characters to their actors

                    actorsInMovie[title] = actorList
                    
                } // end of dealing with credits
                
            
                if let movieIMDBID = jsonDataDictionary["imdb_id"] as? String {
                    imdbID = movieIMDBID
                }
                
                
                let tmdbHolder = [title, posterFileName, overview, releaseDate, runtime, youTubeTrailerId, tmdbID, imdbID] as [Any]
                
                tempTmdbCollection.append(tmdbHolder)
                
                
    
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
 

