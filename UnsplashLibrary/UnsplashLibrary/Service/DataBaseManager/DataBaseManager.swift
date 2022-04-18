//
//  DataBaseManager.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 22.03.2022.
//

import Foundation
import CoreData
import UIKit

class DataBaseManager: DataBaseManagerProtocol {
    // MARK: - Core Data stack
    // MARK: -
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - CoreData data manipulation
    // MARK: -
    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func save(images: [UIImage]) {
        for value in images {
            let photo = FavouritePhoto(context: persistentContainer.viewContext)
            photo.photo = value.pngData() as Data?
            photo.dateCreated = Helpers.dateWithMilliseconds()
            self.saveContext()
        }
    }

    func delete(photos: [FavouritePhoto]) {
        for photo in photos {
            persistentContainer.viewContext.delete(photo)
            saveContext()
        }
    }
}
