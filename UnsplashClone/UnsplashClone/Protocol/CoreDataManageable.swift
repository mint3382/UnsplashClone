//
//  CoreDataManageable.swift
//  UnsplashClone
//
//  Created by minsong kim on 2/2/24.
//

import CoreData

protocol CoreDataManageable {
    var container: NSPersistentContainer { get }
}
