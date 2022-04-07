//
//  HapticsManager.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 07.04.2022.
//

import UIKit

final class HapticsManager {
   static let shared = HapticsManager()

    public func selecrion() {
        DispatchQueue.main.async {
            let selection = UISelectionFeedbackGenerator()
            selection.prepare()
            selection.selectionChanged()
        }
    }

    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
}
