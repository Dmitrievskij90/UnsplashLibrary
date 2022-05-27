//
//  ImagePreviewScreenProtocols.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 24.05.2022.
//

import UIKit

// MARK: - View protocol
// MARK: -
protocol ImagePreviewViewProtocol: AnyObject {
    func dismiss()
    func setPhoto(photo: ImagePreviewModel)
}

// MARK: - Presenter protocol
// MARK: -
protocol ImagePreviewPresenterProtocol: AnyObject {
    var view: ImagePreviewViewProtocol? {get set}
    var dataManager: DataBaseManagerProtocol {get set}
    var imageURL: ImagePreviewModel {get set}

    func favouriteButtonTapped(with imageView: UIImageView)
    func viewWillApperar()
}

// MARK: - Wireframe protocol
// MARK: -
protocol ImagePreviewScreenWireframeProtocol {
    static func createImagePreviewScreenModule(with view: ImagePreviewViewController, and photo: ImagePreviewModel)
}
