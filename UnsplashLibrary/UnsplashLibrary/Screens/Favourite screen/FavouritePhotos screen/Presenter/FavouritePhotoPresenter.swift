//
//  FavouritePhotoPresenter.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 12.04.2022.
//

import Foundation
import CoreData

protocol FavouritePhotoPresenterProtocol: NSFetchedResultsControllerDelegate {
    func reloadData()
    func refresh()
}

class FavouritePhotoPresenter {
    weak var view: FavouritePhotoPresenterProtocol?
    var fetchResultController: NSFetchedResultsController<FavouritePhoto>!
    private let dataManager = DataBaseManager()

    init(view: FavouritePhotoPresenterProtocol) {
        self.view = view
    }

    // MARK: - CoreData methods
    // MARK: -
    func setupFetchResultController() {
        let fetchRequest: NSFetchRequest<FavouritePhoto> = FavouritePhoto.fetchRequest()
        let sotdDescriptor = NSSortDescriptor(key: #keyPath(FavouritePhoto.dateCreated), ascending: true)
        fetchRequest.sortDescriptors = [sotdDescriptor]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = view
        fetchPhotos()
    }

    private func fetchPhotos() {
        do {
            try fetchResultController.performFetch()
        } catch let error {
            print(error)
        }
        view?.reloadData()
    }

    func deletePhotos(_ photos: [FavouritePhoto]) {
        dataManager.delete(photos: photos)
        view?.refresh()
    }


    ////////MARK: - Section Heading
//    private var selectedPhotos = [FavouritePhoto]()
//
//     func resetSeletedPhotos() {
//        selectedPhotos.removeAll()
//        view?.reloadData()
//
//        fetchResultController.fetchedObjects?.indices.forEach { fetchResultController.fetchedObjects?[$0].isSelected = false }
//    }
}
