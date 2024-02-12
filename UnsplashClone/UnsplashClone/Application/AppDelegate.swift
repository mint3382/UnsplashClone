//
//  AppDelegate.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/29/24.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BookmarkData")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
}

