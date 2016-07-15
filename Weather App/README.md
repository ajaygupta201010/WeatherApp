# SwiftProjects
1.City weather
============

City weather is an iOS weather app developed in Swift 2.0. The app is actively adopt the latest features of iOS and Swift language.It shows weather report according to http://api.openweathermap.org/data/2.5/forecast/daily?id=524901&cnt=14&APPID=xxxxx API report.

## Notices
The current version is working with Xcode Version 7.2 and above. If you are using different Xcode version, please download new versions. 

## Version 1
This version support iOS 9 and above only using Swift 2.2.

## Features
* Swift Programming Language - fully upgraded to version 2.2.
* Design driven development.
* Size Classes - Support iPhone 5,5S,6,6S,6Plus,6S Plus and all iPads for only Portrait mode.
* Used Model View Controller Design pattern.
* Showing Image according to the type of weather

## TODO
* 
* UI Tests
* Animations
* Can add another view for forecast weather report after tapping on any one forecast day report.


## How to build and run

1) Open the CityWeather.xcodeproj in Xcode.

2) Check Internet connection.Should have internet connection.

3) Compile and run the app in your simulator or device.

4) You can see two buttons on home screen which are:-
    a) Current city weather - which will show you current city weather using the GPS.
    b) Search by city names - in which user can search weather report of multiple cities by putting names of the cities comma separated. 
5) Once you tapped Search by city names button then you will see text field to enter cities name and search button.
6) when you click on the search button you will get city names table and when you tapped on any city names then it will redirect to city weather report table for 14 days which consisist the date ,weather description,high and low temprature. when you tapped on any table cell you will navigate to detail page of the selected date .
7) When tappimg on search button cities text field should not be empty.

4) If you don't see any data, please check "Simulator" -> "Reset" and then again run.


# Requirements

* Xcode 7.2 and above
* iOS 9 and above