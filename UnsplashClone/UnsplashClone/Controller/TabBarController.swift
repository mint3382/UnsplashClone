//
//  TabBarController.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/29/24.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = .systemGray
        UITabBar.appearance().backgroundColor = .black
        UITabBar.appearance().barTintColor = .black
        setUpViewControllers()
    }
    
    func setUpViewControllers() {
        let main = UINavigationController(rootViewController: MainViewController())
        let randomPhoto = UINavigationController(rootViewController: RandomPhotoViewController())
        
        main.tabBarItem.image = UIImage(named: "house")
        randomPhoto.tabBarItem.image = UIImage(named: "cards")
        
        viewControllers = [main, randomPhoto]
    }
}
