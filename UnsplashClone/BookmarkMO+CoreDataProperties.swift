//
//  BookmarkMO+CoreDataProperties.swift
//  UnsplashClone
//
//  Created by minsong kim on 2/2/24.
//
//

import Foundation
import CoreData


extension BookmarkMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookmarkMO> {
        return NSFetchRequest<BookmarkMO>(entityName: "Bookmark")
    }

    @NSManaged public var likedByUser: Bool
    @NSManaged public var urls: String?
    @NSManaged public var id: UUID?
    @NSManaged public var width: Int64
    @NSManaged public var altDescription: String?
    @NSManaged public var height: Int64
    @NSManaged public var title: String?
    @NSManaged public var descriptions: String?
    @NSManaged public var user: UserMO?

}

extension BookmarkMO : Identifiable { }
