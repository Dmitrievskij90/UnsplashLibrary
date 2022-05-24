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
        let imageModel = ImagePreviewModel(name: image)
        let destinationVC = ImagePreviewViewController()
        destinationVC.modalPresentationStyle = .overFullScreen
        ImagePreviewScreenWireframe.createImagePreviewScreenModule(with: destinationVC, and: imageModel)
        destinationVC.transitioningDelegate = view as? UIViewControllerTransitioningDelegate
        view.present(destinationVC, animated: true, completion: nil)
    }

    class func createSearchScreenModule(with view: PhotosSearchViewController) {
        let presenter = PhotoSearchPresenter(view: view, networkService: NetworkService(), dataManager: DataBaseManager(), wireframe: SearchScreenWireframe())
        view.presenter = presenter
    }
}
