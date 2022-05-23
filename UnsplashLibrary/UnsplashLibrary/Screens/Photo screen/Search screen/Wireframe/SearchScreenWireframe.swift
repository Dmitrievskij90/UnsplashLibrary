//
//  SearchScreenWireframe.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 23.05.2022.
//

import UIKit

class SearchScreenWireframe: SearchScreenWireframeProtocol {
    func presentImagePreviewController(with image: String, from view: UIViewController) {
        HapticsManager.shared.vibrate(for: .success)
        let imageName = ImagePreviewModel(name: image)
        let destinationVC = ImagePreviewViewController(imageURL: imageName)
        destinationVC.transitioningDelegate = view as? UIViewControllerTransitioningDelegate
        view.present(destinationVC, animated: true, completion: nil)
    }

    class func createSearchScreenModule(with view: PhotosSearchViewController) {
        let presenter = PhotoSearchPresenter()

        view.presenter = presenter
        view.presenter?.dataManager = DataBaseManager()
        view.presenter?.wireframe = SearchScreenWireframe()
        view.presenter?.networkService = NetworkService()
        view.presenter?.view = view
    }
}
