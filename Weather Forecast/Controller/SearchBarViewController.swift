//
//  SearchBarViewController.swift
//  Weather Forecast
//
//  Created by Elif Kasapoglu on 13.11.2021.
//


import Foundation
import MapKit
import UIKit

//MARK: - UITableViewDataSource
extension WeatherViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

//MARK: - UITableViewDelegate
extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let coordinate = response?.mapItems[0].placemark.coordinate else {
                return
            }
            self.weatherManager.fetchWeather(latitude: coordinate.latitude, longitute: coordinate.longitude)
            self.searchBar.text = ""
            self.searchResultsTable.isHidden = true
            
        }
    }
    
}

//MARK: - UISearchBarDelegate
extension WeatherViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == ""{
            self.searchResultsTable.isHidden = true
        }else{
            self.searchResultsTable.isHidden = false
        }
        searchCompleter.queryFragment = searchText
    }
}



//MARK: - MKLocalSearchCompleterDelegate
extension WeatherViewController: MKLocalSearchCompleterDelegate{

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        searchResults = completer.results
        self.searchResults = completer.results.filter { result in
            if !result.title.contains(",") {
                return false
            }
            return true
        }
        searchResultsTable.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search Completer error: \(error)")
    }
    
}
