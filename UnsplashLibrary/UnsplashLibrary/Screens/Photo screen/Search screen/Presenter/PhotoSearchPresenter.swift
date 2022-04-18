//
//  PhotoSearchPresenter.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 08.04.2022.
//

import UIKit

class PhotoSearchPresenter {
    private var timer: Timer?
    private var networkService: NetworkServiceProtocol
    private let dataManager: DataBaseManagerProtocol
    weak var view: PhotoSearchPresenterProtocol?

    init(view: PhotoSearchPresenterProtocol, dataManager: DataBaseManagerProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.dataManager = dataManager
        self.networkService = networkService
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

    func cancelButtonPressed() {
        networkService.page = 0
        networkService.searchTerm = ""
    }

    // MARK: - dataManager methods
    // MARK: -
    func savePhotos(images: [UIImage]) {
        dataManager.save(images: images)
        view?.refresh()
    }
}
