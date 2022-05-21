//
//  DataBaseManagerProtocol.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 18.04.2022.
//

import UIKit
import CoreData

protocol DataBaseManagerProtocol {
    var persistentContainer: NSPersistentContainer {get set}
    func save(images: [UIImage])
    func delete(photos: [FavouritePhoto])
}
