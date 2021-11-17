//
//  WeatherManager.swift
//  Weather Forecast
//
//  Created by Elif Kasapoglu on 12.11.2021.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    //private let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=043ea596fe999d25fdd5ee6741bc809a&units=metric"
    
    private let weatherURL = "https://api.openweathermap.org/data/2.5/onecall?appid=043ea596fe999d25fdd5ee6741bc809a&units=metric&lang=tr&exclude=minutely"
    
    var delegate : WeatherManagerDelegate?
    
    /*
     func fetchWeather(cityName: String){
     let urlString = "\(weatherURL)&q=\(cityName)"
     performRequest(with: urlString)
     }*/
    
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
            /*let weather =  WeatherModel(conditionId: decodedData.weather[0].id,
             cityName: decodedData.name,
             temperature: decodedData.main.temp,
             description: decodedData.weather[0].description)*/
           
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
    
}
