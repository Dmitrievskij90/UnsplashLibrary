//
//  FavouriteScreenProtocols.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 21.05.2022.
//

import Foundation
import CoreData

protocol FavouritePhotoViewProtocol: NSFetchedResultsControllerDelegate {
    func reloadData()
    func refresh()
}

protocol FavouritePhotoPresenterProtocol {
    var view: FavouritePhotoViewProtocol? {get set}
    var dataManager: DataBaseManagerProtocol {get set}
    var fetchResultController: NSFetchedResultsController<FavouritePhoto>! {get set}
    var selectedPhotos: [FavouritePhoto] {get set}

    func viewWillApperar()
    func deleteBarButtonTapped()
    func selectBarButtonTapped()
}
