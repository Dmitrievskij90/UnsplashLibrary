//
//  ActivityControllerButton.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 03.04.2022.
//

import UIKit

class ActivityControllerButton: UIButton {

    private var label: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        return label
    }()

    private let accessoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .gray
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .init(hex: 0xfffff0)
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
    convenience init(text: String, imageName: String) {
        self.init(frame: .zero)
        label.text = text
        accessoryImageView.image = UIImage(systemName: imageName)
    }
}
