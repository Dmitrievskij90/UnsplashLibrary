//
//  FavouritePhotoPresenter.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 12.04.2022.
//

import Foundation
import CoreData


class FavouritePhotoPresenter: FavouritePhotoPresenterProtocol {
    weak var view: FavouritePhotoViewProtocol?
    var fetchResultController: NSFetchedResultsController<FavouritePhoto>!
    var selectedPhotos = [FavouritePhoto]()
    var dataManager: DataBaseManagerProtocol
    
    init(view: FavouritePhotoViewProtocol, dataManager: DataBaseManagerProtocol) {
        self.view = view
        self.dataManager = dataManager
    }

    func viewWillApperar() {
        setupFetchResultController()
    }

    func deleteBarButtonTapped() {
        deletePhotos()
    }

    func selectBarButtonTapped() {
        resetSeletedPhotos()
    }

    private func setupFetchResultController() {
        let fetchRequest: NSFetchRequest<FavouritePhoto> = FavouritePhoto.fetchRequest()
        let sotdDescriptor = NSSortDescriptor(key: #keyPath(FavouritePhoto.dateCreated), ascending: true)
        fetchRequest.sortDescriptors = [sotdDescriptor]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController?.delegate = view
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
    
    private func deletePhotos() {
        dataManager.delete(photos: selectedPhotos)
        view?.refresh()
    }
    
    private func resetSeletedPhotos() {
        selectedPhotos.removeAll()
        view?.reloadData()
        
        fetchResultController.fetchedObjects?.indices.forEach { fetchResultController.fetchedObjects?[$0].isSelected = false }
    }
}
