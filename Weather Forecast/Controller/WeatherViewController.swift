//
//  ViewController.swift
//  Weather Forecast
//
//  Created by Elif Kasapoglu on 12.11.2021.
//

import UIKit
import CoreLocation
import Foundation
import MapKit



class WeatherViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTable: UITableView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var hourlyWeatherArray :[(Double, Double, String, Int)] = [] //[(time,temparature,desc,id)]
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        searchCompleter.delegate = self
        searchBar?.delegate = self
        searchResultsTable?.delegate = self
        searchResultsTable?.dataSource = self

        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.requestLocation()
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
            let location = CLLocation(latitude: weather.lat, longitude: weather.long)
            location.placemark { placemark, error in
                guard let placemark = placemark else {
                    print("Error:", error ?? "nil")
                    return
                }
                
                var cityName = ""
                    if let country = placemark.country {
                        cityName = "\(country)"
                    }
                    if let state = placemark.administrativeArea {
                        cityName = "\(state), " + cityName
                    }
                    if let town = placemark.locality {
                        cityName =  "\(town), " + cityName
                    }
              print(cityName)
                self.cityLabel.text = cityName
            }
            self.temperatureLabel.text = weather.tempString
            self.descriptionLabel.text = weather.description
            self.hourlyWeatherArray = weather.hourlyTemp
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
extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}
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
