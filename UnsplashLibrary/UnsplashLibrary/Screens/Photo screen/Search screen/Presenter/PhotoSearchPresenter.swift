//
//  PhotoSearchPresenter.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 08.04.2022.
//

import UIKit

class PhotoSearchPresenter: PhotoSearchPresenterProtocol {
    private var timer: Timer?
    weak var view: PhotoSearchViewProtocol?
    var networkService: NetworkServiceProtocol
    var dataManager: DataBaseManagerProtocol
    var wireframe: SearchScreenWireframeProtocol

    init(view: PhotoSearchViewProtocol, networkService: NetworkServiceProtocol, dataManager: DataBaseManagerProtocol, wireframe: SearchScreenWireframeProtocol) {
        self.view = view
        self.networkService = networkService
        self.dataManager = dataManager
        self.wireframe = wireframe
    }

    // MARK: - networkService methods
    // MARK: -
    func searchPhotos(with searchText: String) {
        networkService.searchTerm = searchText
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkService.searchPhotos { [weak self] result, error in
                if let err = error {
                    fatalError("Error: \(err)")
                }
                if let saveData = result?.results {
                    let photos = saveData.compactMap { PhotoModel(imageURL: $0.urls.regular)}
                    DispatchQueue.main.async {
                        self?.view?.setPhotos(photos: photos)
                        self?.view?.refresh()
                    }
                }
            }
        })
    }

    func searchNextPhotos() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkService.fetchNextPage { [weak self] result, error in
                if let err = error {
                    fatalError("Error: \(err)")
                }

                if let saveData = result?.results {
                    let photos = saveData.compactMap { PhotoModel(imageURL: $0.urls.regular)}
                    DispatchQueue.main.async {
                        self?.view?.addPhotos(photos: photos)
                    }
                }
            }
        })
    }

    // MARK: - Actions
    // MARK: -
    func saveBarButtonTapped(images: [UIImage]) {
        dataManager.save(images: images)
        view?.refresh()
    }

    func cancelButtonPressed() {
        networkService.page = 1
        networkService.searchTerm = ""
    }

    func presentImagePreviewController(with image: String, from view: UIViewController) {
        wireframe.presentImagePreviewController(with: image, from: view)
    }
}
