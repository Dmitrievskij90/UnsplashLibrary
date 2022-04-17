//
//  PhotoSearchPresenter.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 08.04.2022.
//

import UIKit

protocol PhotoSearchPresenterProtocol: AnyObject {
    func setPhotos(photos: [PhotoModel])
    func addPhotos(photos: [PhotoModel])
    func refresh()
}

class PhotoSearchPresenter {
    var selectedPhotos = [UIImage]()
    let dataManager = DataBaseManager()
    let networkService = NetworkService()
    private var timer: Timer?

    weak var view: PhotoSearchPresenterProtocol?

    init(view: PhotoSearchPresenterProtocol) {
        self.view = view
    }

    func searchPhotos(with searchText: String) {
        networkService.searchTerm = searchText
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkService.searchPhoto { [weak self] result, error in
                if let err = error {
                    print("we hawe probler", err)
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
            self.networkService.searchNextPhoto { [weak self] result, error in
                if let err = error {
                    print("we hawe probler", err)
                }

                if let saveData = result?.results {
                    let photos = saveData.compactMap { PhotoModel(imageURL: $0.urls.regular)}
                    DispatchQueue.main.async {
                        self?.view?.addPhotos(photos: photos)
//                        self?.view?.refresh()
                    }
                }
            }
        })
    }

    func savePhotos(images: [UIImage]) {
        dataManager.save(images: images)
        view?.refresh()
    }

    func cancelButtonPressed() {
        networkService.page = 0
        networkService.searchTerm = ""
    }
}
