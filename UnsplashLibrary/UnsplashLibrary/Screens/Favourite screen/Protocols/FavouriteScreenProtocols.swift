//
//  FavouriteScreenProtocols.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 21.05.2022.
//

import UIKit
import CoreData

protocol FavouritePhotoViewProtocol: NSFetchedResultsControllerDelegate {
    func reloadData()
    func refresh()
}

protocol FavouritePhotoPresenterProtocol {
    var fetchResultController: NSFetchedResultsController<FavouritePhoto>! {get set}
    var selectedPhotos: [FavouritePhoto] {get set}

    init(view: FavouritePhotoViewProtocol, dataManager: DataBaseManagerProtocol, wireframe: FavouriteScreenWireframeProtocol)

    func viewWillApperar()
    func deleteBarButtonTapped()
    func selectBarButtonTapped()
    func showFullPhoto(with photo: FavouritePhoto, from view: UIViewController)
}

protocol FavouriteScreenWireframeProtocol: AnyObject {
    func presentImageDetailsViewController(with photo: FavouritePhoto, from view: UIViewController)
    static func createFavouriteScreenModule(with: FavouritePhotoViewController)
}
