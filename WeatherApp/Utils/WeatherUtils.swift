//
//  WeatherUtils.swift
//  WeatherApp
//
//  Created by Srinivas Kasanna on 12/26/17.
//  Copyright © 2017 asdf. All rights reserved.
//

import Foundation
import UIKit

/***
 Utils class contains the all re usable methods those can used across the application where ever we need to do some task.
 ***/

struct WeatherUtils{
    
    /**
     To show the alert in the application
     - parameter controller:  Controller which need to display alert
     - parameter title:  Title for alert
     - parameter message:  Message for alert
     */
    static func showAlert(controller: UIViewController, title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
        }
        
        alertController.addAction(okAction)
        controller.present(alertController, animated: true, completion: nil)
    }

    /**
     To create the url for wetaher details service
     - parameter city:  City name entered by user
     */
    static func searchURLByCity(city: String) -> URL? {
        let escapedCityString = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let escapedCity = escapedCityString else
        {
            print("ProjectWorld:Something wrong in the URL")
            return nil
        }
        return URL(string: WEATHER_URL_STRING + "?q=\(String(describing: escapedCity)),US&appid=\(WEATHER_APP_ID)")
    }
    
    /**
     To create the url for wetaher Icon
     - parameter iconString:  icon name got in web service reponse
     */
    static func urlForIcon(iconString: String?) -> URL? {
        guard let iconString = iconString else {
            return nil
        }
        return URL(string: WEATHER_ICON_URL_STRING+"\(iconString).png")!
    }
    
}
