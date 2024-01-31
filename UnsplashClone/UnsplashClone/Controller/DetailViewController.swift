//
//  DetailViewController.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/31/24.
//

import UIKit

class DetailViewController: UIViewController, ImageViewDownloadable {
    static let identifier = "DetailViewController"
    var item: PhotoElement
    var image: UIImage?
    
    let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.distribution = .equalSpacing
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    //TODO: 각 라벨 및 버튼 위치가 매번 다르지 않게 수정할 것
    let barStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
//        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        
        return stackView
    }()

    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .white
        
        
        return label
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .white
        
        return label
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .white
        label.numberOfLines = 2
        
        return label
    }()
    let downloadButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "download")?.resize(targetSize: CGSize(width: 30, height: 30))
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(tappedDownloadButton), for: .touchUpInside)
        
        return button
    }()
    let bookmarkButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "bookmark")?.resize(targetSize: CGSize(width: 30, height: 30))
        let action = UIAction { _ in
            if button.layer.opacity == 0.1 {
                button.layer.opacity = 0.7
            } else {
                button.layer.opacity = 0.1
            }
        }
        button.setImage(image, for: .normal)
        button.layer.opacity = 0.1
        button.addAction(action, for: .touchUpInside)
        
        return button
    }()
    let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "close")?.resize(targetSize: CGSize(width: 40, height: 40))
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(tappedCloseButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc func tappedCloseButton() {
        self.dismiss(animated: true)
    }
    
    @objc func tappedDownloadButton() {
        self.downloadImageToGallery(url: item.urls.regular)
    }
    
    init(item: PhotoElement, image: UIImage) {
        self.item = item
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0, alpha: 0.85)
        view.isOpaque = false
        self.imageView.image = image!.resize(targetSize: CGSize(
            width: view.frame.width,
            height: ((Double(item.height) / Double(item.width))) * view.frame.width
        ))
//        configureLabel()
//        configureImage()
        configureStackView()
    }
    
    func configureStackView() {
        self.titleLabel.text = item.title
        self.usernameLabel.text = item.user.username
        self.descriptionLabel.text = item.description
        
        barStackView.addArrangedSubview(closeButton)
        barStackView.addArrangedSubview(usernameLabel)
        barStackView.addArrangedSubview(downloadButton)
        barStackView.addArrangedSubview(bookmarkButton)
        
        informationStackView.addArrangedSubview(titleLabel)
        informationStackView.addArrangedSubview(descriptionLabel)
        
        totalStackView.addArrangedSubview(barStackView)
        totalStackView.addArrangedSubview(imageView)
        totalStackView.addArrangedSubview(informationStackView)
        
        view.addSubview(totalStackView)
        
        NSLayoutConstraint.activate([
//            usernameLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 175),
            totalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            totalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            totalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            totalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureImage() {
        imageView.sizeToFit()
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: imageView.intrinsicContentSize.width),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor)
//            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: imageView.intrinsicContentSize.height),
//            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: CGFloat((item.height / item.width))),
//            imageView.widthAnchor.constraint(equalToConstant: view.frame.width),
//            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: CGFloat((item.height / item.width)))
        ])
    }
    
    func configureLabel() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor)
            titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height)
        ])
    }
}

