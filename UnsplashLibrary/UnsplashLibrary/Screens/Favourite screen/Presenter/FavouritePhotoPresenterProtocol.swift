//
//  FavouritePhotoPresenterProtocol.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 18.04.2022.
//

import Foundation
import CoreData

protocol FavouritePhotoPresenterProtocol: NSFetchedResultsControllerDelegate {
    func reloadData()
    func refresh()
}
