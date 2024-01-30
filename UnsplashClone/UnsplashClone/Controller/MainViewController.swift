//
//  ViewController.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/29/24.
//

import UIKit


class MainViewController: UIViewController {
    private var photos: Photo?
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        view.backgroundColor = .systemBackground
        configureImageView()
        loadPhotos()
    }
    
    func configureImageView() {
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func loadPhotos() {
        let endPoint = EndPoint(queries: nil)
        let apiProvider = APIProvider()
        guard let request = endPoint.configureRequest() else {
            //TODO: 실패 알럿
            return
        }
        
        Task {
            do {
                let photo = try await apiProvider.fetchData(decodingType: Photo.self, request: request)
                print(photo)
                downloadImage(url: photo[0].urls.full)
                //TODO: fetch해서 얻은 photos 넘겨주기
            } catch {
                //TODO: 실패 알럿
                print(error.localizedDescription)
            }
        }
    }
    
    func downloadImage(url: URL) {
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self else {
                return
            }
            
            if let error = error as NSError? {
                print(error.localizedDescription)
                return
            }
            
            guard let data,
                  let image = UIImage(data: data) else {
                print("download error: \(String(describing: error?.localizedDescription))")
                return
            }
            
            Task { @MainActor in
                self.imageView.image = image
            }
        }
        dataTask.resume()
    }
}


