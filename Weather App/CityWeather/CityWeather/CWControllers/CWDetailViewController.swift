//
//  CWDetailViewController.swift
//  CityWeather
//
//  Created by Gupta, Ajay E. on 07/07/16.
//  Copyright © 2016 Gupta,Ajay. All rights reserved.
//

import Foundation
import UIKit

class CWDetailViewController: UIViewController {
    
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var weatherDescLbl: UILabel!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var dayTempLbl: UILabel!
    
    
    @IBOutlet weak var cloudynessLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var speedLbl: UILabel!
    
    @IBOutlet weak var minTempLbl: UILabel!
    @IBOutlet weak var maxTempLbl: UILabel!
    @IBOutlet weak var mrngTempLbl: UILabel!
    @IBOutlet weak var eveTempLbl: UILabel!
    @IBOutlet weak var nightTempLbl: UILabel!
    
    var cityModel:CityWeather?
    
    // MARK: View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cityLbl.text = cityModel?.cityName
        self.dateLbl.text = cityModel?.date
        self.weatherDescLbl.text = cityModel?.weatherMainDesc
        self.dayTempLbl.text = cityModel?.dayTemp
        self.cloudynessLbl.text = cityModel?.cloudiness!
        self.humidityLbl.text = cityModel?.humidity!
        self.speedLbl.text = cityModel?.windSpeed!
        self.minTempLbl.text = cityModel?.minTemp
        self.maxTempLbl.text = cityModel?.maxTemp
        self.mrngTempLbl.text = cityModel?.mornTemp
        self.eveTempLbl.text = cityModel?.eveTemp
        self.nightTempLbl.text = cityModel?.nightTemp
        
        // Setting image according to the weather description
        if cityModel?.weatherMainDesc == "Rain" {
            self.weatherImageView.image = UIImage(named: "Rain")
        }else if cityModel?.weatherMainDesc == "Clouds" {
            self.weatherImageView.image = UIImage(named: "Clouds")
        }else if cityModel?.weatherMainDesc == "Extreme" {
            self.weatherImageView.image = UIImage(named: "Clear")
        }else if cityModel?.weatherMainDesc == "Thunderstorm"{
            self.weatherImageView.image = UIImage(named: "Thunderstorms")
        }else if cityModel?.weatherMainDesc == "Snow"{
            self.weatherImageView.image = UIImage(named: "Snow")
        }else{
            self.weatherImageView.image = UIImage(named: "Clear")
        }
    }

}
