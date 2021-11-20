//
//  HourlyWeatherViewController.swift
//  Weather Forecast
//
//  Created by Elif Kasapoglu on 13.11.2021.
//

import Foundation
import UIKit

class HourlyWeatherViewController: UITableViewController{

    @IBOutlet weak var cityLabel: UILabel!
    var hourlyWeatherArray :[(Double, Double, String, Int)] = [] //[(time,temparature,desc,id)]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "HourlyWeatherCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        let tab1Controller = self.tabBarController?.viewControllers?.first as! WeatherViewController
        self.cityLabel.text = tab1Controller.cityLabel.text
        self.hourlyWeatherArray = tab1Controller.hourlyWeatherArray
    }
    
    
    
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
        
    
    func getColorFromId(with id : Int) -> (UIColor?, UIImage?){
        
        switch id {
        case 200...232:
            return (UIColor(named: "thunderstorm"), UIImage(named: "cloud.bolt"))
        case 300...321:
            return (UIColor(named: "drizzle"), UIImage(named: "cloud.drizzle"))
        case 500...531:
            return (UIColor(named: "rain"), UIImage(named: "cloud.rain"))
        case 600...622:
            return (UIColor(named: "snow"), UIImage(named: "cloud.snow"))
        case 701...781:
            return (.gray, UIImage(named: "cloud.fog"))
        case 800:
            return (UIColor(named: "clear"), UIImage(named: "cloud.bolt"))
        case 801...804:
            return (UIColor(named: "cloud"), UIImage(named: "cloud.bolt"))
        default:
            return (.gray, UIImage(named: "cloud.bolt"))
        }
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  hourlyWeatherArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! HourlyWeatherCell
        
        let item = hourlyWeatherArray[indexPath.row]
        cell.weatherColorView.backgroundColor = getColorFromId(with: item.3)
        cell.weatherColorView.layer.cornerRadius = 5
        
        cell.timeLabel.text = String(Calendar.current.component(.hour, from: Date(timeIntervalSince1970: item.0)).description + ".00")
        
        cell.temperatureLabel.text = String(format: "%.0f °C", item.1)
        cell.descriptionLabel.text = String(item.2)
        
        return cell
    }
}


