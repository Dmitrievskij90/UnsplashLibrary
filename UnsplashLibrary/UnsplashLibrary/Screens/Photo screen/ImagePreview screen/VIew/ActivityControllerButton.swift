//
//  ActivityControllerButton.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 03.04.2022.
//

import UIKit

class ActivityControllerButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                    self.accessoryImageView.tintColor = .init(hex: 0xF900BF)
                    self.label.textColor = .init(hex: 0xF900BF)
                }
            } else {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                    self.accessoryImageView.tintColor = .black
                    self.label.textColor = .black
                }
            }
        }
    }

    private var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()

    private let accessoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .black
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 1, alpha: 0.5)
        addSubview(label)
        addSubview(accessoryImageView)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }

        accessoryImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}

extension ActivityControllerButton {
    func configureButton(text: String, imageName: String) {
        label.text = text
        accessoryImageView.image = UIImage(systemName: imageName)
    }
}
