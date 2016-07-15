//
//  ViewController.swift
//  CityWeather
//
//  Created by Gupta, Ajay E. on 07/07/16.
//  Copyright © 2016 Gupta,Ajay. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var cityWeatherTableView: UITableView!
    @IBOutlet weak var citySearch: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchByCityNameBtn: UIButton!
    @IBOutlet weak var orLbl: UILabel!
    
    var longitude:CLLocationDegrees = 0.0
    var latitude:CLLocationDegrees = 0.0
    
    let response:CWResponse = CWResponse()
    var cityModel:CityWeather?
    let const:Constants = Constants()
    
    let locationManager = CLLocationManager()
    
    var citiesNamesArray:NSArray?
    var isCurrentCitySearch:Bool?
    var cityName:String?
    var selectedCity:String?
    
    // MARK: Method for setting UI elements
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.activityIndicator.hidden = true
        self.cityWeatherTableView.hidden = true
        self.cityLbl.hidden = true
        self.isCurrentCitySearch = false
        self.citySearch.hidden = true
        self.searchBtn.hidden = true
        self.citySearch.delegate = self
    
    }

    // Calling Network Class and setting values on UI
    func setValues(city:String){
        let showerNetworkManagerController:CWNetworkManager = CWNetworkManager()
        showerNetworkManagerController.getResultDictionary(city){[weak self](result : NSDictionary?) -> () in
            self!.response.parseQueryDictionary(result!)
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self!.activityIndicator.hidden = true
                
                if result != nil{
                    
                    if self!.isCurrentCitySearch == true{
                        
                        self?.cityLbl.hidden = false
                        self?.cityLbl.text = self?.cityName
                        self!.searchByCityNameBtn.hidden = false
                        self!.orLbl.hidden = false
                        self!.cityWeatherTableView.delegate = self
                        self!.cityWeatherTableView.dataSource = self
                        self!.cityWeatherTableView.hidden = false
                        self!.cityWeatherTableView.reloadData()
                        self!.activityIndicator.stopAnimating()
                        
                    }else{
                        self?.cityLbl.hidden = false
                        self?.cityLbl.text = self!.cityName
                    }
                    
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Method for getting current city using GPS
    
    // Called when Show Current city weather button tapped
    @IBAction func getCurrentCity(sender: AnyObject) {
        self.cityWeatherTableView.hidden = true
        self.isCurrentCitySearch = true
        self.citySearch.hidden = true
        self.searchBtn.hidden = true
        self.searchByCityNameBtn.hidden = true
        self.orLbl.hidden = true
        
        if Reachability.isConnectedToNetwork() == true {
            // Start Activity controller
            self.activityIndicator.hidden = false
            self.activityIndicator.startAnimating()
        }else{
            // Stop Activity controller and hide loading label
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
            self.showAlert(self.const.noInternetStatusMsg)
        }
       self.initSearchLoc()
    }
    
    // initialize Location Manager
    func initSearchLoc(){
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK:Location Manager Delegate Methods
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        locationManager.stopUpdatingLocation()
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidden = true
        self.searchByCityNameBtn.hidden = false
        self.orLbl.hidden = false
        print("error=\(error)")
    }
    
    func locationManager(manager: CLLocationManager,didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.longitude = locValue.longitude
        self.latitude = locValue.latitude
        
        let location = CLLocation(latitude: self.latitude, longitude: self.longitude)
        print(location)
        
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            print(location)
            if error != nil {
                print("\(self.const.geocodeErrorMsg)" + error!.localizedDescription)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                self.searchByCityNameBtn.hidden = false
                self.orLbl.hidden = false
                self.showAlert("\(self.const.geocodeErrorMsg) \(error!.localizedDescription)")
                return
            }
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                print(pm.locality)
                self.cityName = pm.locality?.capitalizedString
                self.setValues(self.cityName!)
            }else {
                print("\(self.const.geocoderProblemMsg)")
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                self.searchByCityNameBtn.hidden = false
                self.orLbl.hidden = false
                self.showAlert("\(self.const.geocoderProblemMsg)")
            }
        })

    }
    
    // MARK: Table View Data Source Method
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isCurrentCitySearch == true){
        return self.response.resultDict?.valueForKey("cnt") as! Int
        }else {
            return (self.citiesNamesArray?.count)!
        }
    }
    
    // Method for cell creation
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (isCurrentCitySearch == true){
            let cellIdentifier:String = "CellForCurrentCity"
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
        }else{
            let cellIdentifier:String = "CellForCity"
            let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
            cell.textLabel?.text = self.citiesNamesArray![indexPath.row] as? String
            return cell
        }
        
    }
    
    // MARK: Table View Delegate Method
    
    // Method for cell selection
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if isCurrentCitySearch == true{
            self.cityModel = response.responseArray[indexPath.row] as? CityWeather
            self.performSegueWithIdentifier("currentCity", sender: self)
        }else{
            self.selectedCity = citiesNamesArray![indexPath.row] as? String
            self.performSegueWithIdentifier("cityWeather", sender:self)
        }
    }
    
    // MARK: Seque Method
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if isCurrentCitySearch == true{
        let detailVC:CWDetailViewController = segue.destinationViewController as! CWDetailViewController
        detailVC.title = "Weather Report"
        detailVC.cityModel = cityModel
        }else{
            let selectedCityVC:CWSelectedCityViewController = segue.destinationViewController as! CWSelectedCityViewController
            selectedCityVC.title = self.selectedCity
            selectedCityVC.setValues(self.selectedCity!)
        }
    }
    
    //MARK: Search city weather using city names
    
    // Search By City Name button pressed
    @IBAction func searchByCityNameBtnPressed(sender: AnyObject) {
        self.cityLbl.hidden = true
        self.cityWeatherTableView.hidden = true
        self.citySearch.hidden = false
        self.searchBtn.hidden = false
        self.cityWeatherTableView.delegate = nil
        self.cityWeatherTableView.dataSource = nil
        
    }
    
    // Called when Search Button Pressed when searching by city names
    @IBAction func searchBtnPressed(sender: AnyObject) {
        
        self.isCurrentCitySearch = false
        self.cityName = nil
        self.citySearch.resignFirstResponder()
        
        if Reachability.isConnectedToNetwork() == true {
            // Start Activity controller
            self.activityIndicator.startAnimating()
            let citiesString:String? = citySearch.text!
            if  citiesString?.characters.count != 0 {
                let arrayOfCities:NSArray = citiesString!.componentsSeparatedByString(",")
                self.citiesNamesArray = arrayOfCities
                self.cityWeatherTableView.delegate = self
                self.cityWeatherTableView.dataSource = self
                self.cityWeatherTableView.hidden = false
                self.cityWeatherTableView.tableFooterView = UIView()
                self.cityWeatherTableView.reloadData()
            }else{
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                self.showAlert(self.const.emptyCityMsg)
            }
        }else{
            // Stop Activity controller and hide loading label
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
            self.showAlert(self.const.noInternetStatusMsg)
        }
    }
    
    //MARK: Text field delegate methods
    
    // Method called when keyboard done button tapped
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
   
    //MARK:Alert View Methods
    
    // Show Alert View
    func showAlert(msg:String){
        let alert = UIAlertController(title: self.const.alertTitle, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}

