//
//  FWSearchVC.swift
//  FreeWeatherApp
//
//  Created by Andrii Melnyk on 4/23/24.
//

import UIKit
import MapKit

class FWSearchVC: UIViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate, UISearchResultsUpdating {
    
    let searchController = UISearchController()
    var searchBar: UISearchBar!
    
    var searchTableView: UITableView!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureSearchController()
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    func configureTableView() {

        searchTableView = UITableView(frame: CGRect(x: 0, y: 0 , width: view.frame.width, height: view.frame.height))
        searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        searchTableView.dataSource = self
        searchTableView.delegate = self
        self.view.addSubview(searchTableView)
    }
    
    func configureSearchController() {
      
        searchCompleter.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search ..."
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = ""
        searchResults.removeAll()
        searchTableView.reloadData()
        print("Cancel tapped !!!! ")
    }
    func updateSearchResults(for searchController: UISearchController) {
        searchCompleter.queryFragment = searchController.searchBar.text!
    }
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        self.searchResults = completer.results.filter { result in
            
            if !result.title.contains(",") {return false}
            if result.title.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {return false}
            if result.subtitle.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {return false}
            return true
        }
        
        searchTableView.reloadData()
    }
    
}

extension FWSearchVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchResult = searchResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}
extension FWSearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            
            guard let name = response?.mapItems[0].name else { return  }
            
            
        }
    }
}
