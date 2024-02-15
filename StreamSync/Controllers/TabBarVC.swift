//
//  TabVC.swift
//  StreamSync
//
//  Created by Deniz Dilbilir on 08/02/2024.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isTranslucent = true
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tabBar.tintColor = .white
        tabBar.barTintColor = .white
        


        
        let homeVC = UINavigationController(rootViewController: HomeVC())
        let searchVC = UINavigationController(rootViewController: SearchVC())
        let comingSoonVC = UINavigationController(rootViewController: ComingSoonVC())
        let downloadsVC = UINavigationController(rootViewController: DownloadsVC())
        
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        comingSoonVC.tabBarItem.image = UIImage(systemName: "play.tv")
        downloadsVC.tabBarItem.image = UIImage(systemName: "arrow.down")
        
        homeVC.title = "Home"
        searchVC.title = "Search"
        comingSoonVC.title = "Coming Soon"
        downloadsVC.title = "Downloads"
        
        let myColor = UIColor(hex: "#a70000")
        tabBar.tintColor = myColor
        
        setViewControllers([homeVC, searchVC, comingSoonVC, downloadsVC], animated: true)
       
    }
    

}
