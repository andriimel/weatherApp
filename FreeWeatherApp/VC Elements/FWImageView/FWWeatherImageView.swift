//
//  FWWeatherImageView.swift
//  FreeWeatherApp
//
//  Created by Andrii Melnyk on 4/23/24.
//

import UIKit

class FWWeatherImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        
         clipsToBounds = true
       
        layer.borderColor = UIColor.darkGray.cgColor
        backgroundColor = .clear
       
        translatesAutoresizingMaskIntoConstraints = false
    }

}
