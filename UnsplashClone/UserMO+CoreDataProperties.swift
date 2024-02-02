//
//  UserMO+CoreDataProperties.swift
//  UnsplashClone
//
//  Created by minsong kim on 2/2/24.
//
//

import Foundation
import CoreData


extension UserMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserMO> {
        return NSFetchRequest<UserMO>(entityName: "User")
    }

    @NSManaged public var username: String?
    @NSManaged public var id: String?
    @NSManaged public var bookmark: BookmarkMO?

}

extension UserMO : Identifiable { }
