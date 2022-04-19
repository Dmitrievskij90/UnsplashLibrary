//
//  ImagePreviewPresenter.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 11.04.2022.
//

import UIKit

class ImagePreviewPresenter {
    private let dataManager: DataBaseManagerProtocol
    weak var view: ImagePreviewPresenterProtocol?

    init(view: ImagePreviewPresenterProtocol, dataManager: DataBaseManagerProtocol ) {
        self.view = view
        self.dataManager = dataManager
    }

    func saveImage(with imageView: UIImageView) {
        var imageArray = [UIImage]()
        guard let image = imageView.image else { return }
        imageArray.append(image)
        dataManager.save(images: imageArray)
        view?.dismiss()
    }
}
