//
//  MainViewController.swift
//  UnsplashClone
//
//  Created by minsong kim on 2/2/24.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        view.backgroundColor = .systemBackground
        updateBookMarkViewController()
        updateRecentImageViewController()
    }
    
    func updateBookMarkViewController() {
        let bookmarkController = BookmarkViewController()
        addChild(bookmarkController)
        view.addSubview(bookmarkController.view)
//        configure
        view.addConstraints(bookmarkController.view.constraints)
        
             
        bookmarkController.didMove(toParent: self)
    }
    
    func updateRecentImageViewController() {
        let recentImageController = RecentImageViewController()
        addChild(recentImageController)
        view.addSubview(recentImageController.view)
        view.addConstraints(recentImageController.view.constraints)
             
        recentImageController.didMove(toParent: self)
    }
}
