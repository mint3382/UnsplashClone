//
//  APIProvider.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/30/24.
//

import Foundation

struct APIProvider {
    func configureRequest(url: URL, method: String = HTTPMethod.get.typeName) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        return request
    }
}
