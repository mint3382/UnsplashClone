//
//  DetailElement.swift
//  UnsplashClone
//
//  Created by minsong kim on 2/2/24.
//

import Foundation

struct DetailElement: Hashable {
    let id: UUID
    let title: String
    let width: Int
    let height: Int
    let descriptions: String?
    let altDescription: String
    let urls: String
    let likedByUser: Bool
    let user: User
}
