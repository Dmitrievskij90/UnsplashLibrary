//
//  UIViewController+UIAlertController.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 09.04.2022.
//

import UIKit

extension UIViewController {
    enum AlertControllerType {
        case add
        case delete
    }

    func createAlertController(type: AlertControllerType, array: [Any]) -> UIAlertController {
        switch type {
        case .add:
            let alertController = UIAlertController(title: "Add to favorites?", message:" \(Helpers.countDescription(array: array)) will be added", preferredStyle: .alert)
            return alertController
        case .delete:
            let alertController = UIAlertController(title: "Delete photo", message: " \(Helpers.countDescription(array: array)) will be delete", preferredStyle: .alert)
            return alertController
        }
    }
}
