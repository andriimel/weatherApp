//
//  FWTabBarController.swift
//  FreeWeatherApp
//
//  Created by Andrii Melnyk on 4/23/24.
//

import UIKit

class FWTabBarController: UITabBarController  {

    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UITabBar.appearance().tintColor = .systemGreen
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = . systemBackground

        appearance.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 30)
        ]
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 15)
        ]

        navigationController?.navigationBar.isTranslucent = true
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
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
