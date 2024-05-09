//
//  FWCurrentWeatherCell.swift
//  FreeWeatherApp
//
//  Created by Andrii Melnyk on 4/23/24.
//

import UIKit

class FWCurrentWeatherCell: UICollectionViewCell {
    
    static let cellIdentifier = "FWCurrentWeatherCell"
    //let location = Response.self
    let locationLabel = FWLocationLabel(withFontSize:  20)
    let tempLabel = FWTempLabel(withFontSize: 80)
    let descriptionLabel = FWDescriptionLabel(withFontSize: 12)
    
   // let location : Response
    let imageView = FWWeatherImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setWeather( forLocation location: WeatherResponse ) {
        locationLabel.text = location.resolvedAddress
        tempLabel.text = String(format:"%.0f",location.currentConditions.temp) + "°"
        descriptionLabel.text = location.description
    }
    
    private func addToView(){
        contentView.addSubview(locationLabel)
        contentView.addSubview(tempLabel)
        contentView.addSubview(descriptionLabel)
    }
    
    private func configure() {

        backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        addToView()
        configureConctrains()
        layer.cornerRadius = 10
        
    
    }
    
    private func configureConctrains() {
        NSLayoutConstraint.activate([
        
            locationLabel.topAnchor.constraint(equalTo: topAnchor, constant: contentView.frame.height/8),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            locationLabel.heightAnchor.constraint(equalToConstant: 50),
            
            tempLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            tempLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100),
            tempLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -100),
            tempLabel.heightAnchor.constraint(equalToConstant: 100),
            
            descriptionLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentView.frame.height/4),
        
        ])
    }
    
}
