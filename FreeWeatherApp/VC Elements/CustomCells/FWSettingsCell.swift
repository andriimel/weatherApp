//
//  FWSettingsCell.swift
//  FreeWeatherApp
//
//  Created by Andrii Melnyk on 5/2/24.
//

import UIKit

class FWSettingsCell: UITableViewCell {

    static let  cellIdentifier = "FWSettingsCell"
    var isCheck = false
    let settingLabel = FWDescriptionLabel(withFontSize: 15)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: FWSettingsCell.cellIdentifier)
        configure()
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configure() {
        addSubview(settingLabel)
        
        NSLayoutConstraint.activate([
            settingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            settingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            settingLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width * 0.4),
            settingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant:  -10)
            
        ])
    }
}
