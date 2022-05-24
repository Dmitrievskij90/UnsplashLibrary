//
//  ImagePreviewScreenWireframe.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 24.05.2022.
//

import UIKit

class ImagePreviewScreenWireframe: ImagePreviewScreenWireframeProtocol {
    class func createFruitDetailModule(with view: ImagePreviewViewController, and photo: ImagePreviewModel) {
        let presenter = ImagePreviewPresenter()
        presenter.imageURL = photo
        view.presenter = presenter
        view.presenter?.view = view
        view.presenter?.dataManager = DataBaseManager()
        view.presenter?.wireframe = ImagePreviewScreenWireframe()
     }
}
