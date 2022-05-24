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

protocol ImagePreviewPresenterProtocol {
    var dataManager: DataBaseManagerProtocol? {get set}
    var view: ImagePreviewViewProtocol? {get set}
    var imageURL: ImagePreviewModel? {get set}
    var wireframe: ImagePreviewScreenWireframeProtocol? {get set}

    func favouriteButtonTapped(with imageView: UIImageView)
    func viewWillApperar()
}

protocol ImagePreviewScreenWireframeProtocol {
    static func createFruitDetailModule(with view: ImagePreviewViewController, and photo: ImagePreviewModel)
}
