//
//  TabBarController.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/29/24.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = .systemGray
        UITabBar.appearance().backgroundColor = .black
        UITabBar.appearance().barTintColor = .black
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        setUpViewControllers()
    }
    
    private func setUpViewControllers() {
        let main = MainViewController()
        let randomPhoto = RandomPhotoViewController()
        
        main.tabBarItem.image = UIImage(named: "house")
        randomPhoto.tabBarItem.image = UIImage(named: "cards")
        
        viewControllers = [main, randomPhoto]
    }
}
