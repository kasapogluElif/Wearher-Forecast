//
//  WeatherManager.swift
//  Weather Forecast
//
//  Created by Elif Kasapoglu on 12.11.2021.
//

import Foundation
import CoreLocation
import UIKit

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    private let weatherURL = "https://api.openweathermap.org/data/2.5/onecall?appid=043ea596fe999d25fdd5ee6741bc809a&units=metric&lang=en&exclude=minutely"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(latitude: CLLocationDegrees, longitute: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        print(urlString)
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let weather = parseJSON(safeData){
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData =  try decoder.decode(WeatherData.self, from: weatherData)
            let decodedHourlyData = decodedData.hourly.map { hourData in
                return (hourData.dt,hourData.temp,hourData.weather[0].description,hourData.weather[0].id)
            }
            
            let weather = WeatherModel(conditionId: decodedData.current.weather[0].id,
                                       lat: decodedData.lat,
                                       long: decodedData.lon,
                                       temperature: decodedData.current.temp,
                                       description: decodedData.current.weather[0].description,
                                       hourlyTemp: decodedHourlyData
            )
            return weather
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    // converts the id into related color and symbol image
    static func convertId(with id : Int) -> (UIColor?, UIImage?){
        switch id {
        case 200...232:
            return (UIColor(named: "thunderstorm"), UIImage(systemName: "cloud.bolt"))
        case 300...321:
            return (UIColor(named: "drizzle"), UIImage(systemName: "cloud.drizzle"))
        case 500...531:
            return (UIColor(named: "rain"), UIImage(systemName: "cloud.rain"))
        case 600...622:
            return (UIColor(named: "snow"), UIImage(systemName: "cloud.snow"))
        case 701...781:
            return (.gray, UIImage(named: "cloud.fog"))
        case 800:
            return (UIColor(named: "clear"), UIImage(systemName: "sun.max"))
        case 801...804:
            return (UIColor(named: "cloud"), UIImage(systemName: "cloud.bolt"))
        default:
            return (.gray, UIImage(systemName: "cloud"))
        }
    }
    
}
