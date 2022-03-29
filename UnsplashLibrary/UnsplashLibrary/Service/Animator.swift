//
//  Animator.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 28.03.2022.
//

import UIKit

final class Animator: NSObject {
  var originFrame = CGRect()
  var presenting = true
  private let duration: TimeInterval = 1
}

extension Animator: UIViewControllerAnimatedTransitioning {
  func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
    duration
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    //1) Set up transition
    let containerView = transitionContext.containerView

    guard let imageDetailView = transitionContext.view(forKey: presenting ? .to : .from)
    else { return }

    let (initialFrame, finalFrame) =
      presenting
      ? (originFrame, imageDetailView.frame)
      : (imageDetailView.frame, originFrame)

    let scaleTransform =
      presenting
      ? CGAffineTransform(
        scaleX: initialFrame.width / finalFrame.width,
        y: initialFrame.height / finalFrame.height
      )
      : .init(
        scaleX: finalFrame.width / initialFrame.width,
        y: finalFrame.height / initialFrame.height
      )

    if presenting {
      imageDetailView.transform = scaleTransform
      imageDetailView.center = .init(x: initialFrame.midX, y: initialFrame.midY)
    }

    imageDetailView.layer.cornerRadius = presenting ? 18 / scaleTransform.a : 0
    imageDetailView.clipsToBounds = true

    if let toView = transitionContext.view(forKey: .to) {
      containerView.addSubview(toView)
    }

    containerView.bringSubviewToFront(imageDetailView)

    guard let imageDetailsContainer =
      ( transitionContext.viewController(forKey: presenting ? .to : .from)
        as? ImageDetailsViewController
      )?.view
    else { return }

    //2) Animate!
    UIView.animate(
      withDuration: duration,
      delay: 0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0,
      animations: {
        imageDetailView.layer.cornerRadius = self.presenting ? 0 : 20 / scaleTransform.a
        imageDetailView.transform = self.presenting ? .identity : scaleTransform
        imageDetailView.center = .init(x: finalFrame.midX, y: finalFrame.midY)
        imageDetailsContainer.alpha = self.presenting ? 1 : 0
      },
      completion: { _ in
          //3) Complete transition
        transitionContext.completeTransition(true)
      }
    )
  }
}


