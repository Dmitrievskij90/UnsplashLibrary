//
//  String+Extension.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 21.03.2022.
//

import Foundation

extension String {
    func getCurrentDate(_ dateFormat: String = "yyyy MMM dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let dataString = dateFormatter.string(from: Date())
        return dataString
    }

}
