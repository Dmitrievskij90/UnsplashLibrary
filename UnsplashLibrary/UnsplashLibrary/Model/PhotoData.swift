//
//  PhotoData.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 19.03.2022.
//

import Foundation

struct PhotoData: Codable {
    let results: [Results]
}

struct Results: Codable {
    let width: Int
    let urls: Photo
}

struct Photo: Codable {
    let regular: String
}
