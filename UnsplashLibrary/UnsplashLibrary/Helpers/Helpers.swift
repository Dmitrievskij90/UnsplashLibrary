//
//  Helpers.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 22.03.2022.
//

import Foundation

class Helpers {
    static func dateWithMilliseconds() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd H:mm:ss.SSSS"
        let dateWithMilliseconds = dateFormatter.string(from: Date())
        return dateWithMilliseconds
    }
}
