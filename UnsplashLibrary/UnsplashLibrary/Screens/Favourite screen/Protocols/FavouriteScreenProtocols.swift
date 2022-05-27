//
//  FavouriteScreenProtocols.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 21.05.2022.
//

import UIKit
import CoreData

// MARK: - View protocol
// MARK: -
protocol FavouritePhotoViewProtocol: NSFetchedResultsControllerDelegate {
    func reloadData()
    func refresh()
}

// MARK: - Presenter protocol
// MARK: -
protocol FavouritePhotoPresenterProtocol {
    var view: FavouritePhotoViewProtocol? {get set}
    var dataManager: DataBaseManagerProtocol {get set}
    var wireframe: FavouriteScreenWireframeProtocol {get set}
    var fetchResultController: NSFetchedResultsController<FavouritePhoto>! {get set}
    var selectedPhotos: [FavouritePhoto] {get set}

    func viewWillApperar()
    func deleteBarButtonTapped()
    func selectBarButtonTapped()
    func showFullPhoto(with photo: FavouritePhoto, from view: UIViewController)
}

// MARK: - Wireframe protocol
// MARK: -
protocol FavouriteScreenWireframeProtocol: AnyObject {
    func presentImageDetailsViewController(with photo: FavouritePhoto, from view: UIViewController)
    static func createFavouriteScreenModule(with: FavouritePhotoViewController)
}
