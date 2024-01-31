//
//  ImageViewDownloadable.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/30/24.
//

import UIKit

protocol ImageViewDownloadable {
    var imageView: UIImageView { get set }
}

extension ImageViewDownloadable {
    func downloadImage(url: URL) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
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
    
    func downloadImageToGallery(url: URL) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error as NSError? {
                print(error.localizedDescription)
                return
            }
            
            guard let data,
                  let image = UIImage(data: data) else {
                print("download error: \(String(describing: error?.localizedDescription))")
                return
            }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            print("다운로드 완료")
        }
        dataTask.resume()
    }
}
