//
//  NetworkError.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/30/24.
//

enum NetworkError: Error {
    case dataTaskFail
    case responseCasting
    case invalidStatus
    case noData
    case invalidURL
}
