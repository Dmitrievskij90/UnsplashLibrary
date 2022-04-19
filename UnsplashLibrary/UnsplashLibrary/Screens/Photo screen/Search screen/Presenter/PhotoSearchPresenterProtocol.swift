//
//  PhotoSearchPresenterProtocol.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 18.04.2022.
//

import Foundation

protocol PhotoSearchPresenterProtocol: AnyObject {
    func setPhotos(photos: [PhotoModel])
    func addPhotos(photos: [PhotoModel])
    func refresh()
}
