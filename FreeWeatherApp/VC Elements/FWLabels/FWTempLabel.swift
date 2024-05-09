//
//  FWTempLabel.swift
//  WeatherFree
//
//  Created by Andrii Melnyk on 4/22/24.
//

import UIKit

class FWTempLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(withFontSize fontSize:Double) {
        self.init(frame: .zero)
        
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }

    func configure() {
        
        backgroundColor = .green
        
        textAlignment = .center
        font = .systemFont(ofSize: 20)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
