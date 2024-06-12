//
//  FWCustomSettingsView.swift
//  FreeWeatherApp
//
//  Created by Andrii Melnyk on 5/1/24.
//

import UIKit

protocol FWCustomSettingsViewDelegate: AnyObject {
    func getSettingsDataForWeather (with metricUnit: String)
}

class FWCustomSettingsView: UIView {
    
    var delegate :FWCustomSettingsViewDelegate?
    
    let tableView = UITableView()
    

        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Settings.plist")

    var settingsList :[FWSettingData] = [FWSettingData(unitName: "US, °F, miles", check: true),FWSettingData(unitName: "Metric, °C, km", check: false),FWSettingData(unitName: "UK, °C, miles", check: false)]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTableView()
        configure()
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {

        backgroundColor = .clear
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray3.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
   
    func configureTableView() {
        loadData()
        addSubview(tableView)
        tableView.register(FWSettingsCell.self , forCellReuseIdentifier: FWSettingsCell.cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame             = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        tableView.rowHeight         = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .green
        tableView.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
        
    }
   
}
   
extension FWCustomSettingsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FWSettingsCell.cellIdentifier, for: indexPath as IndexPath ) as! FWSettingsCell
        
        let settingUnit = settingsList[indexPath.row]
        cell.accessoryType = settingUnit.check ? .checkmark : .none
        cell.settingLabel.text = settingUnit.unitName
        
        cell.selectionStyle = .default
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        settingsList[indexPath.row].check = false
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        settingsList[indexPath.row].check = !settingsList[indexPath.row].check
        if indexPath.row == 0  {
               
                    settingsList[1].check = false
                    settingsList[2].check = false
                    self.delegate?.getSettingsDataForWeather(with: "us")
                }
                else if indexPath.row == 1 {
                    
                    settingsList[0].check = false
                    settingsList[2].check = false
                    self.delegate?.getSettingsDataForWeather(with: "metric")
                } else if indexPath.row == 2{
                    settingsList[0].check = false
                    settingsList[1].check = false
                    delegate?.getSettingsDataForWeather(with: "uk")
                }

        
        self.isHidden = true

        saveDate()
        
    }
    
    func saveDate() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(settingsList)
            try data.write(to: dataFilePath!)
        } catch {
            print(error.localizedDescription)
        }
        self.tableView.reloadData()
    }
    
    
    /* load data from plist file */
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
}
