//
//  Constants.swift
//  CityWeather
//
//  Created by Gupta, Ajay E. on 11/07/16.
//  Copyright © 2016 Gupta,Ajay. All rights reserved.
//

import Foundation

class Constants:NSObject {
    
    let emptyCityMsg:String = "Please Insert City Names"
    let wrongCityNameMsg:String = "Please Enter Corret City Names"
    let alertTitle:String = "Alert"
    
    // Network Url
    let prefixURLString = "http://api.openweathermap.org/data/2.5/forecast/daily?q="
    let suffixURLString = "&cnt=14&APPID=c1cda13e755073432910d11a3e0d97ae"
    
    // Errors
    let badAccessError:String = "Bad Access Error"
    let noInternetStatusMsg:String = "No Internet Connection"
    let geocodeErrorMsg:String = "Reverse geocoder failed with error"
    let geocoderProblemMsg:String = "Problem with the data received from geocoder"
}
