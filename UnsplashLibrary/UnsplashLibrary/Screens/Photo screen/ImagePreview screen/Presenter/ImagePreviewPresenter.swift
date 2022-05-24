//
//  ImagePreviewPresenter.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 11.04.2022.
//

import UIKit

class ImagePreviewPresenter: ImagePreviewPresenterProtocol {
    weak var view: ImagePreviewViewProtocol?
    var wireframe: ImagePreviewScreenWireframeProtocol?
    var imageURL: ImagePreviewModel?
    var dataManager: DataBaseManagerProtocol?

    func viewWillApperar() {
        if let imageModel = imageURL {
            view?.setPhoto(photo: imageModel)
        }
    }

    func favouriteButtonTapped(with imageView: UIImageView) {
        var imageArray = [UIImage]()
        guard let image = imageView.image else { return }
        imageArray.append(image)
        dataManager?.save(images: imageArray)
        view?.dismiss()
    }
}
