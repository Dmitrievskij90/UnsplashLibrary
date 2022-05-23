//
//  FavouriteScreenWireframe.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 21.05.2022.
//

import UIKit

class FavouriteScreenWireframe: FavouriteScreenWireframeProtocol {
    func presentImageDetailsViewController(with photo: FavouritePhoto, from view: UIViewController) {
        if let data = photo.photo as Data?, let image = UIImage(data: data) {
            let destinationVC = ImageDetailsViewController(image: image)
            destinationVC.transitioningDelegate = view as? UIViewControllerTransitioningDelegate
            view.present(destinationVC, animated: true, completion: nil)
        }
    }

    class func createFavouriteScreenModule(with view: FavouritePhotoViewController) {
        let presenter = FavouritePhotoPresenter()

        view.presenter = presenter
        view.presenter.dataManager = DataBaseManager()
        view.presenter.wireframe = FavouriteScreenWireframe()
        view.presenter.view = view
    }
}
