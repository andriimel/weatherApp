//
//  FWSettingsVC.swift
//  FreeWeatherApp
//
//  Created by Andrii Melnyk on 4/30/24.
//

import UIKit

class FWSettingsVC: UIViewController {
    
    var settingView = FWCustomSettingsView(frame: .zero)
    let tableView = UITableView()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.1)
        configure()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
                
        if touch.view?.frame != settingView.frame {
        dismiss(animated: true)
        } else {
            print("You Out")
        }
                
    }
    
    func configure() {
        view.addSubview(settingView)
        
        NSLayoutConstraint.activate([
            settingView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/4),
            settingView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            settingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            settingView.heightAnchor.constraint(equalToConstant: 180)
        
        ])
    }
}

