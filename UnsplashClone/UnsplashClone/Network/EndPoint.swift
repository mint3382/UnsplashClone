//
//  EndPoint.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/30/24.
//

import Foundation

struct EndPoint {
    private let scheme: String = "https"
    private let host: String = "api.unsplash.com"
    private let path: String = "/photos"
    private let queries: [URLQueryItem]?
    
    init(queries: [URLQueryItem]?) {
        self.queries = queries
    }
    
    var url: URL? {
        var component = URLComponents()
        
        component.scheme = scheme
        component.host = host
        component.path = path
        component.queryItems = configureQuery(queries)
        
        return component.url
    }

    private func configureQuery(_ query: [URLQueryItem]?) -> [URLQueryItem] {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            return []
        }
        var queries: [URLQueryItem] = [URLQueryItem(name: "client_id", value: apiKey)]
        
        query?.forEach({ URLQueryItem in
            queries.append(URLQueryItem)
        })
        
        return queries
    }
    
    func configureRequest(method: String = HTTPMethod.get.typeName) -> URLRequest? {
        guard let url = url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        return request
    }
}
