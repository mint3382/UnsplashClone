//
//  PhotoService.swift
//  UnsplashClone
//
//  Created by minsong kim on 2/3/24.
//

import CoreData
import UIKit

final class PhotoService {
    static let shared = PhotoService()
    var container: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).container
    
    private init() {}
    
    func fetchData() -> [DetailElement] {
        var detailElementDatas = [DetailElement]()
        do {
            let photoData = try container.viewContext.fetch(BookmarkMO.fetchRequest())
            photoData.forEach { data in
                if let id = data.id,
                   let title = data.title,
                   let urls = data.urls,
                   let userData = data.user {
                    let user = User(id: userData.id!, username: userData.username!)
                    let photo = DetailElement(id: id, title: title, width: Int(data.width), height: Int(data.height), descriptions: data.descriptions, altDescription:data.altDescription, urls: urls, likedByUser: data.likedByUser, user: user)
                    detailElementDatas.append(photo)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return detailElementDatas
    }
    
    func saveData(_ element: DetailElement) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Bookmark", in: container.viewContext),
              let userEntity = NSEntityDescription.entity(forEntityName: "User", in: container.viewContext) else {
            return
        }
        
        let userData = NSManagedObject(entity: userEntity, insertInto: container.viewContext)
        userData.setValue(element.user.id, forKey: "id")
        userData.setValue(element.user.username, forKey: "username")
        
        let photos = BookmarkMO(entity: entity, insertInto: container.viewContext)
        
        photos.setValue(element.id, forKey: "id")
        photos.setValue(element.title, forKey: "title")
        photos.setValue(element.width, forKey: "width")
        photos.setValue(element.height, forKey: "height")
        photos.setValue(element.descriptions, forKey: "descriptions")
        photos.setValue(element.altDescription, forKey: "altDescription")
        photos.setValue(element.urls, forKey: "urls")
        photos.setValue(true, forKey: "likedByUser")
        photos.setValue(userData, forKey: "user")
        
        
        do {
            try container.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteData(_ photo: DetailElement) {
        let fetchRequest = BookmarkMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", photo.id as CVarArg)
        
        do {
            guard let result = try? container.viewContext.fetch(fetchRequest),
                  let object = result.first else {
                return
            }
            
            container.viewContext.delete(object)
            try container.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func isBookmarkedData(_ photo: PhotoElement) -> Bool {
        let fetchRequest = BookmarkMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", photo.id as CVarArg)
        
        guard let result = try? container.viewContext.fetch(fetchRequest),
              let object = result.first else {
            return false
        }
        
        return object.likedByUser
    }
    
    func isBookmarkExist() -> Bool {
        if fetchData().isEmpty {
            return false
        } else {
            return true
        }
    }
}
