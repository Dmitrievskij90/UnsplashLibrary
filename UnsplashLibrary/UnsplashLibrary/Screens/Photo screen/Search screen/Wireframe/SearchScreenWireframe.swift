//
//  SearchScreenWireframe.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 23.05.2022.
//

import Foundation

class SearchScreenWireframe: SearchScreenWireframeProtocol {
    class func createSearchScreenModule(with view: PhotosSearchViewController) {
        let presenter = PhotoSearchPresenter()

        view.presenter = presenter
        view.presenter?.dataManager = DataBaseManager()
        view.presenter?.wireframe = SearchScreenWireframe()
        view.presenter?.networkService = NetworkService()
        view.presenter?.view = view
    }
}
