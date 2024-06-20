//
//  FWSearchingCell.swift
//  FreeWeatherApp
//
//  Created by Andrii Melnyk on 5/9/24.
//

import UIKit
import CoreData


class FWSearchingCell: UICollectionViewCell,UIGestureRecognizerDelegate {
    
    static let cellIdentifier = "FWSettingsCustomCell"
    let locationLabel = FWLocationLabel(withFontSize:  18)
    let minTempLabel = FWTempLabel(withFontSize: 10)
    let maxTempLabel = FWTempLabel(withFontSize: 10)
    let currentTempLabel = FWTempLabel(withFontSize: 20)
    let descriptionLabel = FWDescriptionLabel(withFontSize: 5)
    let weatherImageView = FWWeatherImageView(frame: .zero)
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Settings.plist")
    
    var settingsList :[FWSettingData] = []
    
    var deleteLabel1: UILabel!
    var deleteLabel2: UILabel!
    var pan: UIPanGestureRecognizer!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cyan
        loadData()
        configure()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addToView(){
        
        addSubview(locationLabel)
        addSubview(descriptionLabel)
        addSubview(weatherImageView)
        addSubview(currentTempLabel)
        addSubview(minTempLabel)
        addSubview(maxTempLabel)
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
    
    func setWeather( forLocation location: SelectedCities ) {
        var temp = ""
        locationLabel.text = location.city?.before(first: ",")
        
        if settingsList[0].check == true {
            print("US metric system !!!!")
            currentTempLabel.text = String (format: "%.0f", location.currentTemp ) + "F"
        } else if settingsList[1].check == true {
            print("EU metric system !!!!")
            currentTempLabel.text = String (format:"%.0f",(location.currentTemp - 32) * 5/9) + "°"
        } else {
            print("UK metric system !!!!")
            currentTempLabel.text = String (format:"%.0f",(location.currentTemp - 32) * 5/9) + "°"
        }
       
        descriptionLabel.text = location.descript
        
    }
   
    private func configure() {

        deleteLabel2 = UILabel()
        deleteLabel2.text = "delete"
        deleteLabel2.textColor = UIColor.white
        deleteLabel2.backgroundColor = .systemRed
        self.insertSubview(deleteLabel2, belowSubview: self.contentView)
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
        
        locationLabel.backgroundColor = .red
        descriptionLabel.backgroundColor = .clear
        weatherImageView.backgroundColor = .white
        currentTempLabel.backgroundColor = .systemPink
        minTempLabel.backgroundColor = .blue
        maxTempLabel.backgroundColor = .blue
        addToView()
        
        NSLayoutConstraint.activate([
            
            locationLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            locationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            locationLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width/3),
            locationLabel.heightAnchor.constraint(equalToConstant: contentView.frame.height/2),
            
            descriptionLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            descriptionLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width/3),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            //
            //
            weatherImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            weatherImageView.leadingAnchor.constraint(equalTo: locationLabel.trailingAnchor, constant: 10),
            weatherImageView.widthAnchor.constraint(equalToConstant: contentView.frame.width/6),
            weatherImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            //
            currentTempLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            currentTempLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            currentTempLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width/4),
            currentTempLabel.heightAnchor.constraint(equalToConstant: contentView.frame.height/2),
            //
            minTempLabel.topAnchor.constraint(equalTo: currentTempLabel.bottomAnchor, constant: 2),
            minTempLabel.leadingAnchor.constraint(equalTo: currentTempLabel.leadingAnchor),
            minTempLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width*0.1),
            minTempLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            maxTempLabel.topAnchor.constraint(equalTo: currentTempLabel.bottomAnchor, constant: 2),
            maxTempLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            maxTempLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width*0.1),
            maxTempLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
            
        ])
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (pan.state == UIGestureRecognizer.State.changed) {
            let p: CGPoint = pan.translation(in: self)
            let width = self.contentView.frame.width
            let height = self.contentView.frame.height
            
            self.contentView.frame = CGRect(x: p.x,y: 0, width: width, height: height);
            //self.deleteLabel1.frame = CGRect(x: p.x - deleteLabel1.frame.size.width-10, y: 0, width: width, height: height)
            self.deleteLabel2.frame = CGRect(x: p.x + contentView.frame.width  - 100 , y: 0, width: width, height: height)
        }
        
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        self.setNeedsLayout()
        contentView.isHidden = true
        sendSubviewToBack(contentView)
        if pan.state == UIGestureRecognizer.State.ended {
          
                let collectionView: UICollectionView = self.superview as! UICollectionView
                let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
                collectionView.delegate?.collectionView!(collectionView, performAction: #selector(onPan(_:)), forItemAt: indexPath, withSender: self)
                print ("delete !!! ")
            }
        
     
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return  abs((pan.velocity(in: pan.view)).x) > abs((pan.velocity(in: pan.view)).y)

    }
}
