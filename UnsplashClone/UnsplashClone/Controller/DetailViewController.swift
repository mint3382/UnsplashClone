//
//  DetailViewController.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/31/24.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, ImageViewDownloadable {
    static let identifier = "DetailViewController"
    
    var element: DetailElement
    var image: UIImage?
    var container: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).container
    
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
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    //TODO: 각 라벨 및 버튼 위치가 매번 다르지 않게 수정할 것
    let barStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
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
        button.setImage(image, for: .normal)
        button.layer.opacity = 0.1
        button.addTarget(self, action: #selector(tappedBookmarkButton), for: .touchUpInside)
        
        return button
    }()
    let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "close")?.resize(targetSize: CGSize(width: 40, height: 40))
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(tappedCloseButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc func tappedBookmarkButton() {
        if bookmarkButton.layer.opacity == 0.1 {
            bookmarkButton.layer.opacity = 0.7
            saveData()
        } else {
            bookmarkButton.layer.opacity = 0.1
            deleteData(element)
        }
    }
    
    @objc func tappedCloseButton() {
        self.dismiss(animated: true)
    }
    
    @objc func tappedDownloadButton() {
        self.downloadImageToGallery(url: URL(string: element.urls)!)
    }
    
    init(item: PhotoElement, image: UIImage) {
        self.element = DetailElement(id: UUID(), title: item.title, width: item.width, height: item.height, descriptions: item.description, altDescription: item.altDescription, urls: item.urls.regular.absoluteString, likedByUser: item.likedByUser, user: item.user)
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
            height: ((Double(element.height) / Double(element.width))) * view.frame.width
        ))
        configureStackView()
    }
    
    func configureStackView() {
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
        ])
    }
    
    func configureLabel() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height)
        ])
    }
}

extension DetailViewController: CoreDataManageable {
    func saveData() {
        guard let entity = NSEntityDescription.entity(forEntityName: "Bookmark", in: container.viewContext),
              let userEntity = NSEntityDescription.entity(forEntityName: "User", in: container.viewContext) else {
            return
        }
        
        let userData = NSManagedObject(entity: userEntity, insertInto: container.viewContext)
        userData.setValue(element.user.id, forKey: "id")
        userData.setValue(element.user.username, forKey: "username")
        
        let photos = NSManagedObject(entity: entity, insertInto: container.viewContext)
        
        photos.setValue(UUID(), forKey: "id")
        photos.setValue(element.title, forKey: "title")
        photos.setValue(element.width, forKey: "width")
        photos.setValue(element.height, forKey: "height")
        photos.setValue(element.descriptions, forKey: "descriptions")
        photos.setValue(element.altDescription, forKey: "altDescription")
        photos.setValue(element.urls, forKey: "urls")
        photos.setValue(element.likedByUser, forKey: "likedByUser")
        photos.setValue(userData, forKey: "user")
        
        do {
            try container.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteData(_ photo: DetailElement) {
        let fetchRequest = BookmarkMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", photo.id as CVarArg)
        
        do {
            guard let result = try? container.viewContext.fetch(fetchRequest),
                  let object = result.first else {
                return
            }
            
            container.viewContext.delete(object)
            try container.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}


