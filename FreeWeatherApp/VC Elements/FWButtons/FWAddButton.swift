//
//  FWSettingsButton.swift
//  WeatherFree
//
//  Created by Andrii Melnyk on 4/22/24.
//

import UIKit

class FWAddButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        isHidden = true
        backgroundColor = .black
        setTitle("Add", for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
