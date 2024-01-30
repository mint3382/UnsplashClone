//
//  URLs.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/30/24.
//

import Foundation

struct URLs: Decodable, Hashable {
    let raw: URL
    let full: URL
    let regular: URL
    let small: URL
    let thumb: URL
    let smallS3: URL

    enum CodingKeys: String, CodingKey {
        case raw
        case full
        case regular
        case small
        case thumb
        case smallS3 = "small_s3"
    }
}
