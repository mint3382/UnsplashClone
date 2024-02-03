//
//  DetailElement.swift
//  UnsplashClone
//
//  Created by minsong kim on 2/2/24.
//

import Foundation

struct DetailElement: Hashable {
    let id: String
    let title: String
    let width: Int
    let height: Int
    let descriptions: String?
    let altDescription: String?
    let urls: String
    var likedByUser: Bool
    let user: User
}
