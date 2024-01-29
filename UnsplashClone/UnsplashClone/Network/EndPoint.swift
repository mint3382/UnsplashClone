//
//  EndPoint.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/30/24.
//

import Foundation

struct EndPoint {
    private let scheme: String = "http"
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
        var queries: [URLQueryItem] = [URLQueryItem(name: "client_id", value: "")]
        
        query?.forEach({ URLQueryItem in
            queries.append(URLQueryItem)
        })
        
        return queries
    }
}
