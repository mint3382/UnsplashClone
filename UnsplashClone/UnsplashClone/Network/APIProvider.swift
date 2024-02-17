//
//  APIProvider.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/30/24.
//

import Foundation

struct APIProvider {
    //decodable과 결합되서 덜 범용적
    func fetchData(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidStatus
        }
        
        return data
    }
    
    func fetchDecodedData<T: Decodable>(type: T.Type, from url: URL) async throws -> T {
        let data = try await fetchData(from: url)
        let jsonData = try JSONDecoder().decode(type, from: data)
        
        return jsonData
    }
}
