//
//  ImagePreviewScreenProtocols.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 24.05.2022.
//

import UIKit

protocol ImagePreviewViewProtocol: AnyObject {
    func dismiss()
    func setPhoto(photo: ImagePreviewModel)
}

protocol ImagePreviewPresenterProtocol: AnyObject {
    init(view: ImagePreviewViewProtocol, dataManager: DataBaseManagerProtocol, imageURL: ImagePreviewModel)

    func favouriteButtonTapped(with imageView: UIImageView)
    func viewWillApperar()
}

protocol ImagePreviewScreenWireframeProtocol {
    static func createImagePreviewScreenModule(with view: ImagePreviewViewController, and photo: ImagePreviewModel)
}
