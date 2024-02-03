//
//  PhotoCell.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/30/24.
//

import UIKit

class PhotoCell: UICollectionViewCell, Identifiable, ImageViewDownloadable {
    static let id = "PhotoCell"
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImage(title: String, url: URL) {
        downloadImage(url: url)
        titleLabel.text = title
        configureImageUI()
    }
    
    private func configureImageUI() {
        self.addSubview(imageView)
        imageView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -60),
            titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8)
        ])
    }
}
