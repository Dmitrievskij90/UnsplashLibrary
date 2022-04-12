//
//  ImagePreviewPresenter.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 11.04.2022.
//

import UIKit

protocol ImagePreviewPresenterProtocol: AnyObject {
    func dismiss()
}

class ImagePreviewPresenter {
    private let dataManager = DataBaseManager()

    weak var view: ImagePreviewPresenterProtocol?

    init(view: ImagePreviewPresenterProtocol) {
        self.view = view
    }

    func saveImage(with imageView: UIImageView) {
        var imageArray = [UIImage]()
        guard let image = imageView.image else { return }
        imageArray.append(image)
        dataManager.save(images: imageArray)
        view?.dismiss()
    }

}
