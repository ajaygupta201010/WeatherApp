//
//  CWResponse.swift
//  CityWeather
//
//  Created by Gupta, Ajay E. on 07/07/16.
//  Copyright © 2016 Gupta,Ajay. All rights reserved.
//

import Foundation

class CWResponse {
    var listOfForecastArray:NSArray?
    var tempratureDict:NSDictionary?
    var resultDict:NSDictionary?
    var responseArray:NSMutableArray = NSMutableArray()
    
    // MARK: Parse Method
    
    // method for parse response dictionary got from backend and making city response array for each day
    func parseQueryDictionary(resultDict:NSDictionary){
        self.resultDict = resultDict
        self.listOfForecastArray = resultDict.valueForKey("list") as? NSArray
        
        let list = [Int](0...13)
        for arrayIndex in list{
            let city:CityWeather = CityWeather()
            
            var tempDict:NSMutableDictionary?
            tempDict = resultDict.valueForKey("city") as? NSMutableDictionary
            city.cityName = tempDict?.valueForKey("name") as? String
            
            
            tempDict = self.listOfForecastArray![arrayIndex] as? NSMutableDictionary
            self.tempratureDict = tempDict?.valueForKey("temp") as? NSDictionary
            
            var temp:Double?
            temp = self.tempratureDict?.objectForKey("day") as? Double
            city.dayTemp = self.kalvinToCelciusTempConvertor(temp!) as String
            
            
            temp = self.tempratureDict?.objectForKey("min") as? Double
            city.minTemp = self.kalvinToCelciusTempConvertor(temp!) as String
            
            temp = self.tempratureDict?.objectForKey("max") as? Double
            city.maxTemp = self.kalvinToCelciusTempConvertor(temp!) as String
            
            temp = self.tempratureDict?.objectForKey("morn") as? Double
            city.mornTemp = self.kalvinToCelciusTempConvertor(temp!) as String
            
            temp = self.tempratureDict?.objectForKey("eve") as? Double
            city.eveTemp = self.kalvinToCelciusTempConvertor(temp!) as String
            
            temp = self.tempratureDict?.objectForKey("night") as? Double
            city.nightTemp = self.kalvinToCelciusTempConvertor(temp!) as String
            
            tempDict = self.listOfForecastArray![arrayIndex] as? NSMutableDictionary
            let unixTime:NSNumber = tempDict?.valueForKey("dt") as! NSNumber
            let unixDate = NSTimeInterval(unixTime)
            
            city.date = self.unixTimestampToDateConvertor(unixDate)
            
            let weatherArray:NSArray?
            weatherArray = tempDict?.valueForKey("weather") as? NSArray
            tempDict = weatherArray![0] as? NSMutableDictionary
            
            city.weatherMainDesc = tempDict?.objectForKey("main") as? String
            city.weatherCondition = tempDict?.objectForKey("description") as? String
            
            tempDict = self.listOfForecastArray![arrayIndex] as? NSMutableDictionary
            
            var temporaryObj:NSNumber?
            temporaryObj = tempDict?.objectForKey("speed") as? NSNumber
            
            city.windSpeed = String(temporaryObj!.intValue)
            
            temporaryObj = tempDict?.objectForKey("clouds") as? NSNumber
            city.cloudiness = String(temporaryObj!.intValue)
            
            temporaryObj = tempDict?.objectForKey("humidity") as? NSNumber
            city.humidity = String(temporaryObj!.intValue)
            
            city.count = self.resultDict?.valueForKey("cnt") as? Int
            
            responseArray.insertObject(city, atIndex: arrayIndex)
        }
        
        
    }
    
    
    // MARK: Convertor Methods
    
    // Kalvin to Celcius Degree temprature Convertor
    func kalvinToCelciusTempConvertor(kalvin:Double) -> NSString{
        var c:Double
        c = kalvin - 273.15
        let celciusStr = NSString(format: "%.0f", c)
        return celciusStr
    }
    
    // Unix timestamp to Actual date convertor
    func unixTimestampToDateConvertor(timeInterval:NSTimeInterval) -> String{
         let date = NSDate(timeIntervalSince1970: timeInterval)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.stringFromDate(date)
        
        return dateString
    }
}
