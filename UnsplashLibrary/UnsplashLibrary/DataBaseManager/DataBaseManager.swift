//
//  DataBaseManager.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 22.03.2022.
//

import Foundation
import CoreData
import UIKit

class DataBaseManager {
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

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

    func delete(photo: FavouritePhoto) {
//        let user = fetchResultController.object(at: index)
        persistentContainer.viewContext.delete(photo)
        saveContext()
    }
}
