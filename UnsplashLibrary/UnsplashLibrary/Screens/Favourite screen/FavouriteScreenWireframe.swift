//
//  FavouriteScreenWireframe.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 21.05.2022.
//

import Foundation

protocol FavouriteScreenWireframeProtocol: AnyObject {
//  func presentImageDetailsViewController(with photo: FavouritePhoto,from view: UIViewController)
    static func createFavouriteScreenModule(with: FavouritePhotoViewController)
}

class FavouriteScreenWireframe: FavouriteScreenWireframeProtocol {
    class func createFavouriteScreenModule(with view: FavouritePhotoViewController) {
        let presenter = FavouritePhotoPresenter()

        view.presenter = presenter
        view.presenter.dataManager = DataBaseManager()
        view.presenter.wireframe = FavouriteScreenWireframe()
        view.presenter.view = view
    }
}
