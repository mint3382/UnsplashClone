//
//  USer.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/30/24.
//

import Foundation

struct User: Decodable, Hashable {
    let id: String
    let username: String

    enum CodingKeys: String, CodingKey {
        case id
        case username
    }
}
