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
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  hourlyWeatherArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! HourlyWeatherCell
        
        let item = hourlyWeatherArray[indexPath.row]
        cell.weatherColorView.backgroundColor = WeatherManager.convertId(with: item.3).0
        cell.weatherIcon.image = WeatherManager.convertId(with: item.3).1
        cell.weatherColorView.layer.cornerRadius = 5
        
        cell.timeLabel.text = String(Calendar.current.component(.hour, from: Date(timeIntervalSince1970: item.0)).description + ".00")
        
        cell.temperatureLabel.text = String(format: "%.0f °C", item.1)
        cell.descriptionLabel.text = String(item.2)
        
        return cell
    }
}


