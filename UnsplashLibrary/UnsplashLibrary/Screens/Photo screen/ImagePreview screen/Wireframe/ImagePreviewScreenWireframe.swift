//
//  ImagePreviewScreenWireframe.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 24.05.2022.
//

import UIKit

class ImagePreviewScreenWireframe: ImagePreviewScreenWireframeProtocol {
    class func createImagePreviewScreenModule(with view: ImagePreviewViewController, and photo: ImagePreviewModel) {
        let presenter = ImagePreviewPresenter(view: view, dataManager: DataBaseManager(), imageURL: photo)
        view.presenter = presenter
     }
}
