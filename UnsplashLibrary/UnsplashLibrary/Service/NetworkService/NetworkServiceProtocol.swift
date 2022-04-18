//
//  NetworkServiceProtocol.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 18.04.2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func searchPhotos(completion: @escaping (PhotoData?, Error?) -> Void)
    func fetchNextPage(completion: @escaping (PhotoData?, Error?) -> Void)
    var page: Int { get set }
    var searchTerm: String { get set }
}
