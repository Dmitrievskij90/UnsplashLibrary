//
//  SearchScreenProtocols.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 23.05.2022.
//

import UIKit

protocol PhotoSearchViewProtocol: AnyObject {
    func setPhotos(photos: [PhotoModel])
    func addPhotos(photos: [PhotoModel])
    func refresh()
}

protocol PhotoSearchPresenterProtocol {
    var networkService: NetworkServiceProtocol? {get set}
    var dataManager: DataBaseManagerProtocol? {get set}
    var view: PhotoSearchViewProtocol? {get set}
    var wireframe: SearchScreenWireframe? {get set}

    func searchPhotos(with searchText: String)
    func searchNextPhotos()
    func cancelButtonPressed()
    func saveBarButtonTapped(images: [UIImage])
}

protocol SearchScreenWireframeProtocol: AnyObject {
//    func presentImageDetailsViewController(with photo: FavouritePhoto, from view: UIViewController)
    static func createSearchScreenModule(with view: PhotosSearchViewController)
}
