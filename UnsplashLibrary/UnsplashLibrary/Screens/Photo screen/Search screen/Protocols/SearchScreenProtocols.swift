//
//  SearchScreenProtocols.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 23.05.2022.
//

import UIKit

// MARK: - View protocol
//MARK: -
protocol PhotoSearchViewProtocol: AnyObject {
    func setPhotos(photos: [PhotoModel])
    func addPhotos(photos: [PhotoModel])
    func refresh()
}

// MARK: - Presenter protocol
// MARK: -
protocol PhotoSearchPresenterProtocol {
    var view: PhotoSearchViewProtocol? {get set}
    var networkService: NetworkServiceProtocol {get set}
    var dataManager: DataBaseManagerProtocol {get set}
    var wireframe: SearchScreenWireframe {get set}

    func searchPhotos(with searchText: String)
    func searchNextPhotos()
    func cancelButtonPressed()
    func saveBarButtonTapped(images: [UIImage])
    func presentImagePreviewController(with image: String, from view: UIViewController) 
}

// MARK: - Wireframe protocol
// MARK: -
protocol SearchScreenWireframeProtocol: AnyObject {
    func presentImagePreviewController(with image: String, from view: UIViewController)
    static func createSearchScreenModule(with view: PhotosSearchViewController)
}
