//
//  CurrencyApiData.swift
//  Countries
//
//  Created by Osman Balci on 5/27/20.
//  Copyright © 2020 Osman Balci. All rights reserved.
//

 
import Foundation
import SwiftUI

 
// Global list of all currencies accessible in all Swift files
var listOfAllCurrencies = [String]()

 
// Register at https://free.currencyconverterapi.com/ to get your own API key
let myApiKey = /*"14ddb644b116505bbfe8"*/ "3a2b62001295ece6f10b"

 
/*
 ======================================
 MARK: - Obtain All Currencies from API
 ======================================
 */

public func obtainAllCurrenciesFromApi() {

    let apiUrl = "https://free.currconv.com/api/v7/currencies?apiKey=\(myApiKey)"

   
    /*
     *************************
     *   API Documentation   *
     *************************

     The above API URL returns the following JSON object at the top level:

     {
         "results":{
               "ALL":{"currencyName":"Albanian Lek", "currencySymbol":"Lek", "id":"ALL"},

               "XCD":{"currencyName":"East Caribbean Dollar", "currencySymbol":"$", "id":"XCD"},

               "EUR":{"currencyName":"Euro", "currencySymbol":"€", "id":"EUR"},

               "BBD":{"currencyName":"Barbadian Dollar", "currencySymbol":"$", "id":"BBD"},

               "BTN":{"currencyName":"Bhutanese Ngultrum",  "id":"BTN"},

               "BND":{"currencyName":"Brunei Dollar", "currencySymbol":"$", "id":"BND"},

               "XAF":{"currencyName":"Central African CFA Franc",  "id":"XAF"},

               "CUP":{"currencyName":"Cuban Peso", "currencySymbol":"$", "id":"CUP"},

               "USD":{"currencyName":"United States Dollar", "currencySymbol":"$", "id":"USD"},

               "FKP":{"currencyName":"Falkland Islands Pound", "currencySymbol":"£", "id":"FKP"},

               "GIP":{"currencyName":"Gibraltar Pound", "currencySymbol":"£", "id":"GIP"},

               "HUF":{"currencyName":"Hungarian Forint", "currencySymbol":"Ft", "id":"HUF"},

               "IRR":{"currencyName":"Iranian Rial", "currencySymbol":"﷼", "id":"IRR"},

               "JMD":{"currencyName":"Jamaican Dollar", "currencySymbol":"J$", "id":"JMD"},

               "AUD":{"currencyName":"Australian Dollar", "currencySymbol":"$", "id":"AUD"},

                  :

                  :

               "UAH":{"currencyName":"Ukrainian Hryvnia", "currencySymbol":"₴", "id":"UAH"},

               "UZS":{"currencyName":"Uzbekistani Som", "currencySymbol":"лв", "id":"UZS"},

               "TMT":{"currencyName":"Turkmenistan Manat",  "id":"TMT"},

               "GBP":{"currencyName":"British Pound", "currencySymbol":"£", "id":"GBP"},

               "ZMW":{"currencyName":"Zambian Kwacha",  "id":"ZMW"},

               "BTC":{"currencyName":"Bitcoin", "currencySymbol":"BTC", "id":"BTC"},

               "BYN":{"currencyName":"New Belarusian Ruble", "currencySymbol":"p.", "id":"BYN"}

         }

     }

     */

 

    /*
    *******************************
    *   HTTP GET Request Set Up   *
    *******************************
    */

   
    let headers = [

        "accept": "application/json",

        "cache-control": "no-cache",

        "connection": "keep-alive",

        "host": "free.currconv.com"

    ]

 

    let request = NSMutableURLRequest(url: NSURL(string: apiUrl)! as URL,
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

            semaphore.signal()

            return

        }

       

        /*
         ----------------------------------------------------
         🔴 Any 'return' used within the completionHandler

         exits the completionHandler; not the public function
         ----------------------------------------------------
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

            /*
             Foundation framework’s JSONSerialization class is used to convert JSON data
             into Swift data types such as Dictionary, Array, String, Number, or Bool.
             */

            let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,

                               options: JSONSerialization.ReadingOptions.mutableContainers)

 

            if let jsonObject = jsonResponse as? [String: Any] {

               

                if let resultsDictionary = jsonObject["results"] as? [String: Any] {

                   

                    // "EUR":{"currencyName":"Euro", "currencySymbol":"€", "id":"EUR"}

                    for (key, _) in resultsDictionary {

 

                        if let currencyDictionary = resultsDictionary[key] as? [String: Any] {

                           

                            // {"currencyName":"Euro", "currencySymbol":"€", "id":"EUR"}

                            let currencyName = currencyDictionary["currencyName"] as? String

                           

                            listOfAllCurrencies.append("\(currencyName!) (\(key))")

 

                        } else { return }

                       

                    }

                } else { return }

            } else { return }

           

            listOfAllCurrencies.sort()

               

            //  print("listOfAllCurrencies = \(listOfAllCurrencies)")

 

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

 

/*
 =============================================================
 MARK: - Obtain Currency Conversion Rate from the API Directly
 =============================================================
 We are not using a URLSession to obtain the rate in an asynchronous manner
 because the response is so tiny, e.g., {"USD_EUR":0.89359}.
 */

public func currencyConversionRate(from: String, to: String) -> Double {

 

    let apiUrl = "https://free.currconv.com/api/v7/convert?q=\(from)_\(to)&compact=ultra&apiKey=\(myApiKey)"

 

    var apiUrlStruct: URL?

    // Can the given apiUrl String be converted into a URL struct?

    if let urlStruct = URL(string: apiUrl) {

        apiUrlStruct = urlStruct

    } else { return 0.0 }

   

    let jsonData: Data?

   

    do {

        /*
         Try getting the JSON data from the URL and map it into virtual memory, if possible and safe.
         Option mappedIfSafe indicates that the file should be mapped into virtual memory, if possible and safe.
         */

        jsonData = try Data(contentsOf: apiUrlStruct!, options: Data.ReadingOptions.mappedIfSafe)

       

    } catch {

        return 0.0

    }

   

    /*
     JSON object with Attribute-Value pairs corresponds to Swift Dictionary type with
     Key-Value pairs. Therefore, we use a Dictionary to represent a JSON object
     where Dictionary Key type is String and Value type is Any (instance of any type)
     */

    var currencyConversionDataDictionary = Dictionary<String, Any>()

   

    // If jsonData has a value, unwrap it, and put it into jsonDataFromApiUrl

    if let jsonDataFromApiUrl = jsonData {

        // JSON data is obtained from the API

        do {

            /*

             Foundation framework’s JSONSerialization class is used to convert JSON data

             into Swift data types such as Dictionary, Array, String, Number, or Bool.

             */

            let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApiUrl,

                               options: JSONSerialization.ReadingOptions.mutableContainers)

 

            // jsonResponse should be a JSON object as {"USD_EUR":0.89359}

            if let jsonObject = jsonResponse as? [String: Any] {

                currencyConversionDataDictionary = jsonObject

            } else {

                return 0.0

            }

   

        } catch {

            return 0.0

        }

        

    } else {

        return 0.0

    }

   

    // {"USD_EUR":0.89359}

    if let conversionRate = currencyConversionDataDictionary["\(from)_\(to)"] as? Double {

        return conversionRate

    }

    return 0.0

}

 
