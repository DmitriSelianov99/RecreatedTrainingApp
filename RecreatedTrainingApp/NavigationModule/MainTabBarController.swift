//
//  MainTabBarController.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 30.06.2023.
//

import UIKit
class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            // Set the selected index to 1 (the "Statistic" tab)
            //selectedIndex = 0
        }
    
    private func setupTabBar(){
        tabBar.backgroundColor = .specialTabBar
        tabBar.tintColor = .specialDarkGreen
        tabBar.unselectedItemTintColor = .specialGray
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.specialLightBrown.cgColor
    }
    
    private func setupItems(){
        let mainVC = MainViewController()
        let statisicVC = StatisticViewController()
        let profileVC = ProfileViewController()
        
        setViewControllers([mainVC, statisicVC, profileVC], animated: true)
        
        guard let items = tabBar.items else { return }
//        for i in  {
//            items[i].title
//        }
        
        items[0].title = "Main"
        items[1].title = "Statistic"
        items[2].title = "Profile"
        
        items[0].image = UIImage(named: "mainTabBar")
        items[1].image = UIImage(named: "statisticTabBar")
        items[2].image = UIImage(named: "profileTabBar")
        
        UITabBarItem.appearance().setTitleTextAttributes([.font : UIFont(name: "Roboto-Bold", size: 12) as Any], for: .normal)
    }
}
