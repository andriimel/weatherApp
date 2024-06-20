//
//  FWSearchVC.swift
//  FreeWeatherApp
//
//  Created by Andrii Melnyk on 4/23/24.
//

import UIKit
import MapKit
import CoreData


protocol FWSearchedLocationDelegate : AnyObject {
    func getSelectedLocation(with city: String)
}

private enum Section : CaseIterable {
    case main
}

class FWSearchVC: UIViewController, UISearchControllerDelegate {
   
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    weak var delegate: FWSearchedLocationDelegate?
    var searchView = FWSearchView(frame: .zero)
    var collectionView : UICollectionView!
    var city = [SelectedCities]()
    let defaults = UserDefaults.standard
    var selectedCity = ""
    var selectedLocation = MKLocalSearchCompletion()
    let searchController = UISearchController()
    var searchBar: UISearchBar!
    private var dataSource: UICollectionViewDiffableDataSource<Section, SelectedCities>!

    var searchTableView: UITableView!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    var settingsList :[FWSettingData] = []
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Settings.plist")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
      
        
        configureCollectionView()
        
        loadDataFromDB()
        
        loadMetricSettingsData()
        
        configureSearchController()
       // configureTabBarButtons()
    }
    
    func configureTabBarButtons() {
        
      
        
    }
    @objc func searchButtonTapped() {
        print("Search button tapped !!!! ")
        configureSearchController()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
       
    }
    func setNavigationBar() {
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
    }
    
    func loadMetricSettingsData() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                settingsList = try decoder.decode([FWSettingData].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
        print(settingsList)
    }
    

    func setData() {
        delegate?.getSelectedLocation(with: defaults.string(forKey: "SelectedLocation") ?? "")
    }
    
    func configureSearchTableView() {

        searchTableView = UITableView(frame: CGRect(x: searchView.frame.minX, y:searchView.frame.minY , width: searchView.frame.width, height: searchView.frame.height))
        searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.backgroundColor = .red
       
    }
    
    func configureSearchView() {
       
        configureSearchTableView()
        self.view.addSubview(searchView)
        searchView.isHidden = false
        searchView.addSubview(searchTableView)
       
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: self.view.topAnchor),
            searchView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            searchView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    func configureSearchController() {
      
        searchCompleter.delegate = self

        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
//        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
      
    }
}

extension FWSearchVC: FWWeatherDelegate {
    func getWeatherToSelectedLocations(with selectedLocation: WeatherResponse) {

        print("WEATHERVC DELEGATE IS WORKING RIGHRT NOW !!!!! ")
        delegate?.getSelectedLocation(with: selectedCity)

        let newCity = SelectedCities(context: self.context)
        newCity.city = selectedLocation.resolvedAddress
        newCity.descript = selectedLocation.description
            // temperature ??? 
//        if settingsList[0].check == true {
//            print("US metric system !!!!")
//            newCity.currentTemp = selectedLocation.currentConditions.temp
//        } else if settingsList[1].check == true {
//            print("EU metric system !!!!")
//            newCity.currentTemp =  ((selectedLocation.currentConditions.temp + 32)*5)/9
//        } else {
//            print("UK metric system !!!!")
//            newCity.currentTemp =  ((selectedLocation.currentConditions.temp + 32)*5)/9
//        }
        newCity.currentTemp = selectedLocation.currentConditions.temp
    
        self.city.append(newCity)
        saveDataToDB()

    }
    

    // MARK: - Core Data methods
    
    func saveDataToDB() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    func loadDataFromDB(){
        let request : NSFetchRequest<SelectedCities> = SelectedCities.fetchRequest()
        do {
          city =  try context.fetch(request)
        } catch {
            print ("Error loading category\(error)")
        }
    }
}

extension FWSearchVC: UISearchBarDelegate, UISearchResultsUpdating{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = ""
        searchResults.removeAll()
        
        searchView.isHidden = true
        collectionView.isHidden = false
        print("Cancel tapped !!!! ")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchCompleter.queryFragment = searchController.searchBar.text!
//        configureSearchView()
        print("update search is starting!!!")
    }
}

extension FWSearchVC: MKLocalSearchCompleterDelegate {
   
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        print("Search is begin !!!! ")
        configureSearchView()

        collectionView.isHidden = true
        self.searchResults = completer.results.filter { result in
            
            if !result.title.contains(",") {return false}
            if result.title.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {return false}
            if result.subtitle.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {return false}
            return true
        }
        searchTableView.reloadData()
    }
}

extension FWSearchVC: UITableViewDataSource, UITableViewDelegate{
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start {response, error in
            
            guard let name = response?.mapItems[0].name else {return}
            self.defaults.setValue(name, forKey: "SelectedLocation")
           
            let destVC = FWWeatherVC()
          
//            if !self.city.isEmpty {
//             
//                guard  let myCity = self.city[indexPath.row].city  else {
//                        return
//                    }
//                print ("Yes it is !!!!!\(name) ", myCity.before(first: ","))
//
//                    if myCity.before(first: ",").contains(name){
//                        print ("Yes it is !!!!!\(name) ", myCity.before(first: ","))
//                        print(name, "Theay are similar")
//                        destVC.addButton.isHidden = true
//                    } else if  myCity.before(first: ",") != name {
//                        print("They are nor similar !!!!!!! ")
//                        destVC.addButton.isHidden = false
//                    
//                }
//                
//            }
            destVC.addButton.isHidden = false
            self.present(destVC, animated: true)
        }
    }
}

// MARK: - Collection View Methods

extension FWSearchVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    
    func configureCollectionView() {

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
     
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = true
        
        collectionView.register(FWSearchingCell.self, forCellWithReuseIdentifier: FWSearchingCell.cellIdentifier)
        view.addSubview(collectionView)
   
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
}
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(100)) ,
            subitems: [item])
        
        group.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(city.count)
        return city.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FWSearchingCell.cellIdentifier, for: indexPath) as? FWSearchingCell else {fatalError()}
        let addedCity = city[indexPath.row]
        cell.setWeather(forLocation: addedCity)
        
        return cell
    }

     func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        print("swipe was started !!! ")

         let delCity = city[indexPath.row]
         city.remove(at: indexPath.row)
         context.delete(delCity)
         saveDataToDB()
         collectionView.reloadData()

     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
    }

}
