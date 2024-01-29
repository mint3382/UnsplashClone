//
//  APIProvider.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/30/24.
//

import Foundation

struct APIProvider {
    func fetchData<T: Decodable>(decodingType: T.Type, request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidStatus
        }
        
        let jsonData = try JSONDecoder().decode(decodingType, from: data)
        
        return jsonData
    }
}
