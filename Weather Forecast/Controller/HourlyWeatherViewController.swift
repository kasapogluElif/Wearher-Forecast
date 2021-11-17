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
    func getColorFromId(with id : Int) -> UIColor{
        
        switch id {
        case 200...232:
            return .red
        case 300...321:
            return .orange
        case 500...531:
            return .darkGray
        case 600...622:
            return .white
        case 701...781:
            return.gray
        case 800:
            return .yellow
        case 801...804:
            return .blue
        default:
            return .blue
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
        cell.weatherColorView.layer.cornerRadius = 10
        
        cell.timeLabel.text = String(Calendar.current.component(.hour, from: Date(timeIntervalSince1970: item.0)).description + ".00")
        
        cell.temperatureLabel.text = String(format: "%.0f °C", item.1)
        cell.descriptionLabel.text = String(item.2)
        
        return cell
    }
}


