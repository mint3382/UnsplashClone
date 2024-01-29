//
//  Photo.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/29/24.
//

import Foundation

struct Photo: Decodable, Hashable {
    let id: String
    let width: Int
    let height: Int
    let description: String?
    let altDescription: String
    let likedByUser: Bool
    let user: User

    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case description
        case altDescription = "alt_description"
        case likedByUser = "liked_by_user"
        case user
    }
}