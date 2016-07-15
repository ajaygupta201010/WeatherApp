//
//  CWNetworkManager.swift
//  CityWeather
//
//  Created by Gupta, Ajay E. on 07/07/16.
//  Copyright © 2016 Gupta,Ajay. All rights reserved.
//

import Foundation

class CWNetworkManager{
    // Clousure for returning the Result
    typealias FetchingCompletionBlock = (result : NSDictionary?) -> ()
    
    let const:Constants = Constants()
    
    // Network Function for getting Json formate response
    func getResultDictionary(cityStr:String ,complition:FetchingCompletionBlock) ->NSDictionary  {
        
        let urlString:NSString = NSString.init(format: "%@%@%@", self.const.prefixURLString,cityStr.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!,self.const.suffixURLString)
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString as String)!)
        var results:NSDictionary? = [:]
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError!?) in
            do {
                results = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments) as? NSDictionary
                
                complition(result: results)
                // Network Error Handling
                if let unwrappedError = error {
                    print("error=\(unwrappedError)")
                }
            } catch {
                print(self.const.badAccessError)
            }
        }
        task.resume()
        return results!
        
        
    }
    
}