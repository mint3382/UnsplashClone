//
//  ViewController.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/29/24.
//

import UIKit


class MainViewController: UIViewController {
    var imageCollectionView: UICollectionView? = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, Photo>? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        view.backgroundColor = .systemBackground
    }
    
    
}

