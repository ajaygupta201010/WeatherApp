//
//  CWSelectedCityViewController.swift
//  CityWeather
//
//  Created by Gupta, Ajay E. on 10/07/16.
//  Copyright © 2016 Gupta,Ajay. All rights reserved.
//

import Foundation
import UIKit

class CWSelectedCityViewController:UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var cityWeatherTable: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var response:CWResponse = CWResponse()
    var cityModel:CityWeather?
    let const:Constants = Constants()
    
    // UI setting Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cityWeatherTable.hidden = true
        self.activityIndicator.startAnimating()
        self.navigationItem.hidesBackButton = true
        // Checking for internet connection
         if Reachability.isConnectedToNetwork() == true {
         }else{
            self.showAlert(self.const.noInternetStatusMsg)
        }
        
    }
    
    // Calling Network Class and setting values
    func setValues(city:String){
        let showerNetworkManagerController:CWNetworkManager = CWNetworkManager()
        showerNetworkManagerController.getResultDictionary(city){[weak self](result : NSDictionary?) -> () in
            self!.response.parseQueryDictionary(result!)
            
            // For UI updation
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self!.activityIndicator.stopAnimating()
                self!.activityIndicator.hidden = true
                
                if result != nil{
                    self!.cityWeatherTable.hidden = false
                    self!.cityWeatherTable.delegate = self
                    self!.cityWeatherTable.dataSource = self
                    self!.cityWeatherTable.tableFooterView = UIView()
                    self!.cityWeatherTable.reloadData()
                    self!.navigationItem.hidesBackButton = false
                }else{
                    self?.showAlert(self!.const.wrongCityNameMsg)
                }
            })
        }
    }

    // MARK:Table view Data Source methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return self.response.resultDict?.valueForKey("cnt") as! Int
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier:String = "CityCell"
        
            var cell:CurrentCityTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? CurrentCityTableViewCell
            if cell == nil{
                cell = CurrentCityTableViewCell()
            }
            self.cityModel = response.responseArray[indexPath.row] as? CityWeather
            
            cell?.dateLbl.text = cityModel?.date
            cell?.weatherDescLbl.text = cityModel?.weatherMainDesc
            cell?.lowTempLbl.text = cityModel?.minTemp
            cell?.highTempLbl.text = cityModel?.maxTemp
            return cell!
    }
    
    // MARK:Table view Delegate methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
            self.cityModel = response.responseArray[indexPath.row] as? CityWeather
            self.performSegueWithIdentifier("cityWeather", sender: self)
    }
    
    
    // MARK: Seque Method
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailVC:CWDetailViewController = segue.destinationViewController as! CWDetailViewController
        detailVC.title = "Weather Report"
        detailVC.cityModel = cityModel
    }
    
    // MARK : Alert method
    
    // Show Alert View
    func showAlert(msg:String){
        let alert = UIAlertController(title: self.const.alertTitle, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }


}