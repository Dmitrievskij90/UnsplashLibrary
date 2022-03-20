//
//  PhotoCollectionViewCell.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 19.03.2022.
//

import UIKit
import SnapKit
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "checkmark1")
        return imageView
    }()

    var data: String? {
        didSet {
            if let safeData = data {
                imageView.sd_setImage(with: URL(string: safeData))
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        clipsToBounds = true
        layer.cornerRadius = 18
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(named: "black")?.cgColor

        setupImageView()
        setupLikeImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupLikeImageView() {
        imageView.addSubview(likeImageView)
        likeImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
    }
}
