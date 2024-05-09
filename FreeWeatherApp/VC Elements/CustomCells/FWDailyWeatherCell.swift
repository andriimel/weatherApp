//
//  FWDailyWeatherCell.swift
//  FreeWeatherApp
//
//  Created by Andrii Melnyk on 4/24/24.
//

import UIKit

class FWDailyWeatherCell: UICollectionViewCell {
    
    static let cellIdentifier = "FWDailyWeatherCell"
    let dayLabel = FWLocationLabel(withFontSize:  20)
    let weatherImageView = FWWeatherImageView(frame: .zero)
    let minTempLabel = FWTempLabel(withFontSize: 20)
    let maxTempLabel = FWTempLabel(withFontSize: 20)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cyan
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(weatherConditions: Days) {
        
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: weatherConditions.datetime) ?? Date.now
        
        formatter.dateFormat = "EE, d"
        let currentDate = formatter.string(from: date)      
        print("Current date is :",currentDate)
       
        dayLabel.text = currentDate
        minTempLabel.text = String(format:"%.0f",weatherConditions.tempmin) + "°"
        maxTempLabel.text = String(format:"%.0f",weatherConditions.tempmax) + "°"
        weatherImageView.image = UIImage(named: weatherConditions.icon)
        
    }
    private func addToView(){
        contentView.addSubview(dayLabel)
        contentView.addSubview(weatherImageView)
        contentView.addSubview(minTempLabel)
        contentView.addSubview(maxTempLabel)
    }
    
   
    
    private func configure() {
        
        dayLabel.backgroundColor = .red
        minTempLabel.backgroundColor = .green
        maxTempLabel.backgroundColor = .blue
        addToView()
        NSLayoutConstraint.activate([
            
            dayLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            dayLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width/5),
            dayLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
             
            weatherImageView.topAnchor.constraint(equalTo: topAnchor, constant: contentView.frame.height/3),
            weatherImageView.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 10),
            weatherImageView.widthAnchor.constraint(equalToConstant: contentView.frame.height*0.6),
            weatherImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentView.frame.height/3),
            
            minTempLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            minTempLabel.trailingAnchor.constraint(equalTo: maxTempLabel.leadingAnchor, constant: -10),
            minTempLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width/5),
            minTempLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            maxTempLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            maxTempLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            maxTempLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width/5),
            maxTempLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
            
        ])
        
    }
    
}
