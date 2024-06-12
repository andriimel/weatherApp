//
//  FWWeatherVC.swift
//  WeatherFree
//
//  Created by Andrii Melnyk on 4/22/24.
//

import UIKit
import CoreLocation
import MapKit



class FWWeatherVC: UIViewController {
    
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Settings.plist")
    
    var collectionView: UICollectionView!
    
    var settingView = FWCustomSettingsView(frame: .zero)
    var currentLocation:[ WeatherResponse ] = []
    var days : [Days] = []
    var hoursDataWeather : [Hours] = []
    
    var settingUnit = ""
    var settingsList :[FWSettingData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
        configureWeatherVC()
        configureCollectionView()
        configureSettingView()
        getMyLocationWeather()
        setMetricValue()
        print("Weather in: ",settingUnit)
    }
    
    func setMetricValue() {
        settingUnit = defaults.string(forKey: "SettingsValue") ?? "metric"
        settingView.delegate = self
    }
    
    func loadData() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                settingsList = try decoder.decode([FWSettingData].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getMyLocationWeather() {
        
        loadData()
        
        LocationManager.shared.getCurrentLocation { location in
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if (error != nil){
                    print("error in reverseGeocode")
                }
                guard let placemarks = placemarks else {return}
                let placemark = placemarks as [CLPlacemark]
                if placemark.count>0{
                    
                    let placemark = placemarks[0]
                    
                    FWNetworkManager().getApiData(with: placemark.subLocality!, with: self.settingUnit ) { [weak self] result in
                        guard let self = self else {return}
                        switch result {
                            
                        case .success(let days ):
                            
                            self.currentLocation.append(days)
                            self.days.append(contentsOf: days.days)
                            
                            getHoursData(day: days.days[0])
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        case .failure( _ ):
                            print("Error")
                        }
                    }
                }
            }
        }
        
    }
    
    func getHoursData(day: Days) {
        
        hoursDataWeather.append(contentsOf: day.hours)
        
    }
    func configureWeatherVC() {
        
        let settingsButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "gearshape"), target: self, action: #selector(settingsButtonTapped))
        navigationItem.rightBarButtonItem = settingsButton
        
        let locationButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "location.circle"), target: self, action: #selector(locationButtonTapped))
        navigationItem.leftBarButtonItem = locationButton
    }
    
    @objc func settingsButtonTapped(){
        
        settingView.isHidden = !settingView.isHidden
    }
    
    @objc func locationButtonTapped() {
        print("Location button tapped !!!! ")

        reloadData()
        getMyLocationWeather()
        
    }
    
    func reloadData() {
        currentLocation.removeAll()
        days.removeAll()
        hoursDataWeather.removeAll()
        
        // getMyLocationWeather()
    }
    func configureCollectionView() {
        let layout = UICollectionViewCompositionalLayout {sectionIndex, _ in
            return self.layout(for: sectionIndex)
        }
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        
        collectionView.register(FWCurrentWeatherCell.self, forCellWithReuseIdentifier: FWCurrentWeatherCell.cellIdentifier)
        collectionView.register(FWHourlyWeatherCell.self, forCellWithReuseIdentifier: FWHourlyWeatherCell.cellIdentifier)
        collectionView.register(FWDailyWeatherCell.self, forCellWithReuseIdentifier: FWDailyWeatherCell.cellIdentifier)
        
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

    }
    
    func configureSettingView() {
        view.addSubview(settingView)
        
        
        settingView.isHidden = true
        
        NSLayoutConstraint.activate([
            settingView.topAnchor.constraint(equalTo:  view.topAnchor, constant: 100),
            settingView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            settingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            settingView.heightAnchor.constraint(equalToConstant: 180)
            
        ])
    }
    
    private func layout(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let section = CurrentWeatherSection.allCases[sectionIndex]
        
        switch section {
        case .current:
            let item = NSCollectionLayoutItem(layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            ))
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.75)),
                subitems: [item]
            )
            
            return NSCollectionLayoutSection(group: group)
        case .hourly:
            let item = NSCollectionLayoutItem(layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            ))
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(widthDimension: .fractionalWidth(0.25),
                                  heightDimension: .absolute(100)),
                subitems: [item]
            )
            group.contentInsets = .init(top: 1, leading: 2, bottom: 1, trailing: 2)
            
            let section =  NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            return section
        case .daily:
            let item = NSCollectionLayoutItem(layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            ))
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                  heightDimension: .absolute(100)),
                subitems: [item]
            )
            group.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            return NSCollectionLayoutSection(group: group)
        }
    }
    
}
extension FWWeatherVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 2 {
            return days.count
        } else if section == 0 {
            return currentLocation.count
        } else {return hoursDataWeather.count }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FWCurrentWeatherCell.cellIdentifier, for: indexPath) as? FWCurrentWeatherCell else {fatalError()}
            
            let curentloc = currentLocation[0]
            cell.setWeather(forLocation: curentloc)
            return cell
        } else if indexPath.section == 1 {
            
            
            guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FWHourlyWeatherCell.cellIdentifier, for: indexPath) as? FWHourlyWeatherCell else {fatalError()}
            
            let date = Date()
            
            // DateFormatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h, a"
            _ = dateFormatter.string(from: date)
            
            
            let hourData = hoursDataWeather[indexPath.row]
            
            cell.setHoursWeather(hour: hourData)
            
            return cell
        } else {
            guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FWDailyWeatherCell.cellIdentifier, for: indexPath) as? FWDailyWeatherCell else {fatalError()}
            cell.set(weatherConditions: days[indexPath.row])
            
            return cell
        }
    }
}

extension FWWeatherVC : FWCustomSettingsViewDelegate {
    
    func getSettingsDataForWeather(with metricUnit: String) {
        self.settingUnit = metricUnit
        defaults.set(metricUnit, forKey: "SettingsValue")
        reloadData()
        getMyLocationWeather()
    }
    
}
