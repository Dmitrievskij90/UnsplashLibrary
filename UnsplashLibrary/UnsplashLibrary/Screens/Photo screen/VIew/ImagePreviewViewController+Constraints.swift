//
//  ImagePreviewViewController+Constraints.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 06.04.2022.
//

import UIKit

extension ImagePreviewViewController {
    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            imageView.snp.makeConstraints { make in
                make.centerY.equalToSuperview().offset(-50)
                make.centerX.equalToSuperview()
                make.height.equalToSuperview().dividedBy(2)
                make.width.equalToSuperview().offset(-40)
            }
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.trailing.equalTo(imageView.snp.trailing)
            make.height.equalTo(80)
            make.width.equalTo(imageView.snp.width).dividedBy(1.5)
        }

        bottomView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }

    func remakeConstraints() {
        let isPortrait = UIDevice.current.orientation
        switch isPortrait {
        case .faceDown, .faceUp, .portrait, .portraitUpsideDown, .unknown:
            portraitConstraints()
        case .landscapeLeft, .landscapeRight:
            landscapeConstraints()
        default:
            portraitConstraints()
        }
    }

    private func portraitConstraints() {
        imageView.snp.remakeConstraints { make in
            make.centerY.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
            make.width.equalToSuperview().offset(-40)
        }

        stackView.snp.remakeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.trailing.equalTo(imageView.snp.trailing)
            make.height.equalTo(80)
            make.width.equalTo(imageView.snp.width).dividedBy(1.5)
        }
    }

    private func landscapeConstraints() {
        imageView.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-50)
            make.height.equalToSuperview().multipliedBy(0.8)
            make.width.equalToSuperview().multipliedBy(0.5)
        }

        stackView.snp.remakeConstraints { make in
            make.width.equalTo(imageView.snp.width).dividedBy(2)
            make.height.equalTo(80)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.bottom.equalTo(imageView.snp.bottom)
        }
    }

}

// MARK: - Orientation Transition Handling
extension ImagePreviewViewController {
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        remakeConstraints()
    }
}
