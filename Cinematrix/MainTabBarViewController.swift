//
//  MainTabBarViewController.swift
//  Cinematrix
//
//  Created by  Mr.Ki on 11.04.2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpcomingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: DownloadsViewController())
                
        vc1.tabBarItem.image = UIImage(systemName: "house.circle")
        vc2.tabBarItem.image = UIImage(systemName: "flag.circle")
        vc3.tabBarItem.image = UIImage(systemName: "chart.line.uptrend.xyaxis.circle")
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.circle")
        
        vc1.title = "Home"
        vc2.title = "New"
        vc3.title = "Popular"
        vc4.title = "Downloads"
        
        tabBar.tintColor = .label
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
        
        
    }


}

