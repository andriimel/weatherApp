//
//  FWSearchView.swift
//  FreeWeatherApp
//
//  Created by Andrii Melnyk on 5/25/24.
//

import UIKit

class FWSearchView: UIView {
  
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    func configure () {
       translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGreen
    }
}

