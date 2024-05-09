//
//  FWHourlyWeatherCell.swift
//  FreeWeatherApp
//
//  Created by Andrii Melnyk on 4/24/24.
//

import UIKit

class FWHourlyWeatherCell: UICollectionViewCell {
    static let cellIdentifier = "FWHourlyWeatherCell"
    
    let hourLabel = FWLocationLabel(withFontSize: 20)
    let tempLabel = FWTempLabel(withFontSize: 25)
    let weatherImage = FWWeatherImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews(){
        addSubview(hourLabel)
        addSubview(tempLabel)
        addSubview(weatherImage)
    }
    
    func setHoursWeather(hour : Hours) {
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let time = dateFormatter.date(from: hour.datetime) ?? Date.now
        
        let datesFormatt = DateFormatter()
        datesFormatt.dateFormat = "h, a"
        let currentTime = datesFormatt.string(from: time)
       
        hourLabel.text = currentTime
        tempLabel.text = String(format: "%.0f", hour.temp) + "°"
        weatherImage.image = UIImage(named: hour.icon)
    }
    private func configure() {
        addSubviews()
        tempLabel.backgroundColor = .white
        NSLayoutConstraint.activate([
        
            hourLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            hourLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            hourLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            hourLabel.heightAnchor.constraint(equalToConstant: contentView.frame.height / 5),
            
            weatherImage.topAnchor.constraint(equalTo: hourLabel.bottomAnchor, constant: 14),
            weatherImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentView.frame.height/3),
            weatherImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentView.frame.height/3),
            weatherImage.bottomAnchor.constraint(equalTo: tempLabel.topAnchor, constant: -6),
            
            tempLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            tempLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            tempLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            tempLabel.heightAnchor.constraint(equalToConstant: contentView.frame.height / 3)
            
        ])
        
    }
}
