//
//  Helpers.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 22.03.2022.
//

import Foundation
import UIKit

class Helpers {
    static func dateWithMilliseconds() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd H:mm:ss.SSSS"
        let dateWithMilliseconds = dateFormatter.string(from: Date())
        return dateWithMilliseconds
    }

    static func countDescription(array: [Any]) -> String {
        switch array.count {
        case 1:
            return " \(array.count) photo"
        case (let count) where count > 1:
            return " \(array.count) photos"
        default:
            return " \(array.count) photo"
        }
    }
}
