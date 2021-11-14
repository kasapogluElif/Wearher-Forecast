//
//  WeatherModel.swift
//  Weather Forecast
//
//  Created by Elif Kasapoglu on 12.11.2021.
//

import Foundation
//import CoreLocation

struct WeatherModel{
    let conditionId: Int
    //let cityName: String
    let lat: Double
    let long: Double
    let temperature: Double
    let description : String
    let hourlyTemp : [(Int,Double,Int)] //[(time,temparature,Id)]

    var tempString:String{
        return String(format: "%.0f", temperature)
    }
    /*
    
    var cityName: String{
        var name = ""
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude:  long) // <- New York

        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
            if let locationName = placemarks?[0].name{
                print(locationName)
                name = locationName
                print(name)
                
            }
        })
        print("name is ")
        print(name)
        return name
    }*/
    
    
    
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
        
}
