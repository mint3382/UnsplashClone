//
//  RandomPhotoViewController.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/29/24.
//

import UIKit

class RandomPhotoViewController: UIViewController, ImageViewDownloadable {
    private var photoItems: [PhotoElement] = []
    private var currentPage: Int?
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var backView: UIView = {
        let view = UIView()
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
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "close2")?.resize(targetSize: CGSize(width: 40, height: 40))
        image?.withTintColor(.white)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(tappedPastButton), for: .touchUpInside)

        button.setImage(image, for: .normal)
        
        return button
    }()
    
    let checkButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "redBookmark")?.resize(targetSize: CGSize(width: 50, height: 50))
        button.backgroundColor = .systemBackground
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(tappedNextButton), for: .touchUpInside)
        
        return button
    }()
    
    let detailButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "information")?.resize(targetSize: CGSize(width: 40, height: 40))
        button.backgroundColor = .systemBackground
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(tappedDetailButton), for: .touchUpInside)
        
        return button
    }()
    
    var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        Task {
            await loadPhotos()
            configureImage()
            configureImageUI()
            configureStackView()
            configureBackView()
        }
    }
    
    @objc func tappedDetailButton() {
        guard let image = imageView.image,
              let currentPage else {
            return
        }
        
        let detailViewController: DetailViewController
        let detailItem = DetailElement(
            id: photoItems[currentPage].id,
            title: photoItems[currentPage].title,
            width: photoItems[currentPage].width,
            height: photoItems[currentPage].height,
            descriptions: photoItems[currentPage].description,
            altDescription: photoItems[currentPage].altDescription,
            urls: photoItems[currentPage].urls.regular.absoluteString,
            likedByUser: PhotoService.shared.isBookmarkedData(photoItems[currentPage]),
            user: photoItems[currentPage].user)
        detailViewController = DetailViewController(item: detailItem, image: image)
        self.present(detailViewController, animated: true)
    }
    
    @objc func tappedNextButton() {
        guard var current = currentPage else {
            return
        }
        current += 1
        
        if current == photoItems.count {
            currentPage = 0
        } else {
            currentPage = current
        }
        configureImage()
        configureImageUI()
    }
    
    @objc func tappedPastButton() {
        guard var current = currentPage else {
            return
        }
        current -= 1
        
        if current == -1 {
            currentPage = photoItems.count - 1
        } else {
            currentPage = current
        }
        
        configureImage()
        configureImageUI()
    }
    
    
    
    func configureImage() {
        guard let currentPage else {
            imageView.image = UIImage(named: "noImage")
            return
        }
        
        let item = photoItems[currentPage]
        
        let url = item.urls.regular
        downloadImage(url: url)
    }
    
    func configureBackView() {
        backView.layer.shadowPath = UIBezierPath(roundedRect: backView.bounds, cornerRadius: backView.layer.cornerRadius).cgPath
        backView.layer.shadowOffset = CGSize(width: 2, height: 2)
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.8
        backView.layer.shadowRadius = 10
    }
    
    private func configureImageUI() {
        view.addSubview(backView)
        backView.addSubview(imageBackView)
        imageBackView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            backView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            backView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            backView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            backView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageBackView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 12),
            imageBackView.heightAnchor.constraint(equalTo: backView.heightAnchor, multiplier: 0.75),
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
    
    private func configureStackView() {
        buttonStackView.addArrangedSubview(closeButton)
        buttonStackView.addArrangedSubview(checkButton)
        buttonStackView.addArrangedSubview(detailButton)
        backView.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: imageBackView.bottomAnchor, constant: 20),
            buttonStackView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -20),
            buttonStackView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 30),
            buttonStackView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -30)
        ])
    }
    
    
    private func loadPhotos() async {
        let endPoint = EndPoint(queries: nil)
        let apiProvider = APIProvider()
        guard let request = endPoint.configureRequest() else {
            //TODO: 실패 알럿
            return
        }
        
        do {
            let photo = try await apiProvider.fetchData(decodingType: Photo.self, request: request)
            photo.forEach { photoElement in
                photoItems.append(photoElement)
            }
            currentPage = 0
        } catch {
            //TODO: 실패 알럿
            print(error.localizedDescription)
        }
    }
}
