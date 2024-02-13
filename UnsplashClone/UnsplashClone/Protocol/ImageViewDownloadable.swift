//
//  ImageViewDownloadable.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/30/24.
//

import UIKit

protocol ImageViewDownloadable { }

extension ImageViewDownloadable {
    func downloadImage(url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidURL
        }
        
        guard let image = UIImage(data: data) else {
            throw NetworkError.noData
        }
        
        return image
    }
}
