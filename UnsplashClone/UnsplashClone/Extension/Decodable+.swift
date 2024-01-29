//
//  Decodable+.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/30/24.
//

import Foundation

extension Decodable {
    func decode(data: Data) -> Self? {
        var result: Self?
        
        do {
            result = try JSONDecoder().decode(Self.self, from: data)
        } catch {
            print(error.localizedDescription)
        }

        return result
    }
}
