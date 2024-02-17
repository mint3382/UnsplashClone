//
//  DetailViewController.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/31/24.
//

import UIKit
import CoreData

final class DetailViewController: UIViewController {
    static let identifier = "DetailViewController"
    var delegate: DetailDelegate?
    private var element: DetailElement
    private var image: UIImage
    
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    //TODO: 각 라벨 및 버튼 위치가 매번 다르지 않게 수정할 것
    private let barStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 12
        
        return stackView
    }()

    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .white
        label.setContentHuggingPriority(.init(1), for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .white
        label.numberOfLines = 2
        
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "download")?.resize(targetSize: CGSize(width: 30, height: 30))
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(tappedDownloadButton), for: .touchUpInside)
        
        return button
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "bookmark")?.resize(targetSize: CGSize(width: 30, height: 30))
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(tappedBookmarkButton), for: .touchUpInside)

        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "close")?.resize(targetSize: CGSize(width: 40, height: 40))
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(tappedCloseButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func tappedBookmarkButton() {
        if element.likedByUser == false {
            bookmarkButton.layer.opacity = 0.7
            element.likedByUser = true
            PhotoService.shared.saveData(element)
        } else {
            bookmarkButton.layer.opacity = 0.1
            element.likedByUser = false
            PhotoService.shared.deleteData(element)
        }
        delegate?.updateSnapshot()
    }
    
    @objc private func tappedCloseButton() {
        self.dismiss(animated: true)
    }
    
    @objc private func tappedDownloadButton() {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    init(item: DetailElement, image: UIImage) {
        self.element = item
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
        self.imageView.image = image.resize(targetSize: CGSize(
            width: view.frame.width,
            height: ((Double(element.height) / Double(element.width))) * view.frame.width
        ))
        if self.element.likedByUser == false {
            bookmarkButton.layer.opacity = 0.1
        } else {
            bookmarkButton.layer.opacity = 0.7
        }
        configureStackView()
    }
    
    private func configureStackView() {
        self.titleLabel.text = element.title
        self.usernameLabel.text = element.user.username
        self.descriptionLabel.text = element.altDescription
        
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
            totalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            totalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            totalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            totalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ])
    }
    
    private func configureImage() {
        imageView.sizeToFit()
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: imageView.intrinsicContentSize.width),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor)
        ])
    }
    
    private func configureLabel() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height)
        ])
    }
}
