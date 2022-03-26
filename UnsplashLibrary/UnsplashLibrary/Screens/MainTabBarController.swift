//
//  MainTabBarController.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 19.03.2022.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [createNavController(viewController: PhotosViewController(), title: "Photos", imageName: "photo.on.rectangle"),
                           createNavController(viewController: FavouritePhotoViewController(), title: "Favourite", imageName: "heart")
        ]
    }

    private func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        viewController.view.backgroundColor = .white
        viewController.navigationItem.title = title
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.navigationBar.prefersLargeTitles = true
        navController.tabBarItem.image = UIImage(systemName: imageName)
        UITabBar.appearance().tintColor = .init(hex: 0xC74B50)

        return navController
    }
}
