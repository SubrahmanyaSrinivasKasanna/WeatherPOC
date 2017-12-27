//
//  WebServiceManager.swift
//  WeatherApp
//
//  Created by Srinivas Kasanna on 12/26/17.
//  Copyright © 2017 asdf. All rights reserved.
//

/***
 Webservice manager is useful to invoke service calls from the application
 ***/

import Foundation

struct WebServiceManager{
    
    static func getWeatherData(requestURL: URL, completionHandler:@escaping (Any?,_ error:Error?)->Void){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let urlRequest = URLRequest(url: requestURL)
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            completionHandler(data,error)
        })
        task.resume()
    }
    
    //should use escaping since the completion block will not execute right away some where at the middle of the closure
    static func getWeatherInformation(url: URL?, completion: @escaping (Data) -> ()) {
        //Using guard, Safe unwrapping the optional value to avoid nil value unwrapping and unwanted app crashes
        guard let url = url else { return }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        session.dataTask(with: url){ (data,response,error) in
            if error != nil {
                print(error?.localizedDescription ?? "Error occured during the networking call")
                return
            }
            guard let data = data else {
                print(error?.localizedDescription ?? "Error in Network Data")
                return
            }
            completion(data)
            }.resume()
        
    }

}
