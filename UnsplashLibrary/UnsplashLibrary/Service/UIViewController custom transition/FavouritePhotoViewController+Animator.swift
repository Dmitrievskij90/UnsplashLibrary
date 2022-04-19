//
//  FavouritePhotoViewController+Animator.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 11.04.2022.
//

import UIKit

extension FavouritePhotoViewController: UIViewControllerTransitioningDelegate {
     func animationController( forPresented _: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        Animator.shared.originFrame = selectedImage.superview!.convert(selectedImage.frame, to: nil)
        Animator.shared.presenting = true
        return Animator.shared
    }

    func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        Animator.shared.presenting = false
        return Animator.shared
    }
}
