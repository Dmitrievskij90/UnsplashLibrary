//
//  DataBaseManagerProtocol.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 18.04.2022.
//

import UIKit

protocol DataBaseManagerProtocol {
    func save(images: [UIImage])
    func delete(photos: [FavouritePhoto])
}
