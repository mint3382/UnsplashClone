//
//  RandomPhotoCell.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/31/24.
//

import UIKit

class RandomPhotoCell: UICollectionViewCell, ImageViewDownloadable {
    static let id = "RandomPhotoCell"
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = .init(gray: 0.8, alpha: 1)
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var imageBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
//        view.layer.borderColor = .init(gray: 0.4, alpha: 0)
//        view.layer.borderWidth = 2
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let checkButton: UIButton = {
        let button = UIButton()
        
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImage(url: URL) {
        downloadImage(url: url)
        configureImageUI()
    }
    
    private func configureImageUI() {
//        imageView.sizeToFit()
        self.addSubview(backView)
        backView.addSubview(imageBackView)
        imageBackView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 12),
            backView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            backView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageBackView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 12),
            imageBackView.heightAnchor.constraint(equalTo: backView.heightAnchor, multiplier: 0.7),
            imageBackView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 12),
            imageBackView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: imageBackView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageBackView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageBackView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageBackView.trailingAnchor)
        ])
    }
}
