//
//  PhotoCollectionViewCell.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 19.03.2022.
//

import UIKit
import SnapKit
import SDWebImage

class PhotoSearchCollectionViewCell: UICollectionViewCell {
     let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 1
        return imageView
    }()

    private let likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.alpha = 0
        return imageView
    }()

    var data: PhotoModel? {
        didSet {
            if let safeData = data {
                imageView.sd_setImage(with: URL(string: safeData.imageURL))
                let isFavorited = safeData.isSelected
                updateState(isSelected: isFavorited)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black

        clipsToBounds = true
        layer.cornerRadius = 18

        setupImageView()
        setupLikeImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateState(isSelected: Bool) {
        imageView.alpha = isSelected ? 0.7 : 1
        likeImageView.alpha = isSelected ? 1 : 0
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
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
