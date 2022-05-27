//
//  FavouritePhotoPresenter.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 12.04.2022.
//

import UIKit
import CoreData

class FavouritePhotoPresenter: FavouritePhotoPresenterProtocol {
    weak var view: FavouritePhotoViewProtocol?
    var dataManager: DataBaseManagerProtocol
    var wireframe: FavouriteScreenWireframeProtocol
    var fetchResultController: NSFetchedResultsController<FavouritePhoto>!
    var selectedPhotos = [FavouritePhoto]()

    init(view: FavouritePhotoViewProtocol, dataManager: DataBaseManagerProtocol, wireframe: FavouriteScreenWireframeProtocol) {
        self.view = view
        self.dataManager = dataManager
        self.wireframe = wireframe
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

    func showFullPhoto(with photo: FavouritePhoto, from view: UIViewController) {
        wireframe.presentImageDetailsViewController(with: photo, from: view)
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
