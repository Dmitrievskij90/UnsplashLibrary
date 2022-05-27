//
//  ImagePreviewPresenter.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 11.04.2022.
//

import UIKit

class ImagePreviewPresenter: ImagePreviewPresenterProtocol {
    weak var view: ImagePreviewViewProtocol?
    var imageURL: ImagePreviewModel
    var dataManager: DataBaseManagerProtocol

    init(view: ImagePreviewViewProtocol, dataManager: DataBaseManagerProtocol, imageURL: ImagePreviewModel) {
        self.view = view
        self.dataManager = dataManager
        self.imageURL = imageURL
    }
    
    func viewWillApperar() {
        view?.setPhoto(photo: imageURL)
    }

    func favouriteButtonTapped(with imageView: UIImageView) {
        var imageArray = [UIImage]()
        guard let image = imageView.image else { return }
        imageArray.append(image)
        dataManager.save(images: imageArray)
        view?.dismiss()
    }
}
