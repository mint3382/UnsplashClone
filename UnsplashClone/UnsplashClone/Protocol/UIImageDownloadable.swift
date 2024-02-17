//
//  ImageViewDownloadable.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/30/24.
//

import UIKit

protocol UIImageDownloadable { 
    var apiProvider: APIProvider { get }
}

extension UIImageDownloadable {
    func downloadImage(url: URL) async throws -> UIImage {
        let data = try await apiProvider.fetchData(from: url)
        
        guard let image = UIImage(data: data) else {
            throw NetworkError.noData
        }
        
        return image
    }
}
