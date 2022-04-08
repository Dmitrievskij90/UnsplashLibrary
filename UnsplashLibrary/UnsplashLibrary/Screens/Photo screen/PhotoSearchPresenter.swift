//
//  PhotoSearchPresenter.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 08.04.2022.
//

import UIKit

protocol PhotoSearchPresenterProtocol {
    var photos: [PhotoModel] { get set }
    var selectedPhotos: [UIImage] { get set }
    var dataManager: DataBaseManager { get }
    var networkService: NetworkService { get }
}

class PhotoSearchPresenter: PhotoSearchPresenterProtocol {
    var photos = [PhotoModel]()
    var selectedPhotos = [UIImage]()
    let dataManager = DataBaseManager()
    let networkService = NetworkService()


    weak var view: PhotosSearchViewController?

    init(view: PhotosSearchViewController) {
        self.view = view
    }

    func searchPhotos(with searchText: String) {
        self.networkService.searchPhoto(searchTerm: searchText) { [weak self] result, error in
            if let err = error {
                print("we hawe probler", err)
            }

            if let saveData = result?.results {
                self?.photos = saveData.compactMap { PhotoModel(imageURL: $0.urls.regular)}
                DispatchQueue.main.async {
                    self?.view?.acrivityIndicator.stopAnimating()
                    self?.view?.collectionView.reloadData()
//                    self?.refresh()
                }
            }
        }
    }

}
