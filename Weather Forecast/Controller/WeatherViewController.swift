//
//  ViewController.swift
//  Weather Forecast
//
//  Created by Elif Kasapoglu on 12.11.2021.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            //locationManager.requestLocation()
        }
        else{
            //weatherManager.fetchWeather(cityName: "ANKARA")
            return
        }

        
    }
    
    
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController : WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            //self.cityLabel.text =  self.coordinateToCity(location: CLLocation(latitude: weather.lat as CLLocationDegrees, longitude: weather.long as CLLocationDegrees)) ?? "empty"
            //self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.tempString
            self.descriptionLabel.text = weather.description
        }
    }
    
    func didFailWithError(error: Error) {
        print("WeatherManager error: \(error)")    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = currentLocation.coordinate.latitude
            let long = currentLocation.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitute: long)
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager error: \(error)")
    }
}

//MARK: - CLLocation Data Manipulation Functions
/*
extension WeatherViewController {
    
    func coordinateToCity(location: CLLocation) -> String?{
        var cityName : String = ""
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            guard error == nil else {
                print("Reverse geocoder failed with error \(error!)")
                return
            }
            
            guard  placemarks != nil else {
                print("Problem with the data received from geocoder")
                return
            }
            cityName = placemarks![0].name ?? "empty name"
            print("insider cityname " + cityName)
            
        })
       print("cityname " + cityName)
        return cityName
    }
}

*/
