//
//  FWTabBarController.swift
//  FreeWeatherApp
//
//  Created by Andrii Melnyk on 4/23/24.
//

import UIKit

class FWTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createWeatherVC(), createSearchVC()]
     
    }
    
    func createWeatherVC() -> UINavigationController {
        let weatherVC = FWWeatherVC()
        weatherVC.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 0)
        return UINavigationController(rootViewController: weatherVC)
    }
    
    func createSearchVC() -> UINavigationController {
        let searchVC = FWSearchVC()
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        return UINavigationController(rootViewController: searchVC)
    }

}
