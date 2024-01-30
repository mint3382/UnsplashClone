//
//  Section.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/30/24.
//

import Foundation

enum Section: Hashable {
    case main
}

enum Item: Hashable {
    case bookmark(PhotoElement)
    case recentImage(PhotoElement)
}

