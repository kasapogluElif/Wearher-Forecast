//
//  SearchBarViewController.swift
//  Weather Forecast
//
//  Created by Elif Kasapoglu on 13.11.2021.
//


import Foundation
import MapKit
import UIKit


class SearchBarViewController: UIViewController{
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTable: UITableView!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.delegate = self
        searchBar?.delegate = self
        searchResultsTable?.delegate = self
        searchResultsTable?.dataSource = self
    }
}

//MARK: - UITableViewDataSource
extension SearchBarViewController: UITableViewDataSource {

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
extension SearchBarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let coordinate = response?.mapItems[0].placemark.coordinate else {
                return
            }

            guard let name = response?.mapItems[0].name else {
                return
            }

            let lat = coordinate.latitude
            let lon = coordinate.longitude

            print(lat)
            print(lon)
            print(name)

        }
    }
}

//MARK: - UISearchBarDelegate
extension SearchBarViewController: UISearchBarDelegate{
       func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           searchCompleter.queryFragment = searchText
       }
}


//MARK: - MKLocalSearchCompleterDelegate
extension SearchBarViewController: MKLocalSearchCompleterDelegate{

     func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
         searchResults = completer.results
         searchResultsTable.reloadData()
     }

     func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
         print("Search Completer error: \(error)")
     }
    
}
