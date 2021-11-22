//
//  WeatherModel.swift
//  Weather Forecast
//
//  Created by Elif Kasapoglu on 12.11.2021.
//

import Foundation
import CoreLocation

struct WeatherModel{
    let conditionId: Int
    let lat: Double
    let long: Double
    let temperature: Double
    let description : String
    let hourlyTemp : [(Double,Double,String,Int)] //[(time,temparature,desc,id)]

    var tempString:String{
        return String(format: "%.0f °C", temperature)
    }
}
