//
//  PhotoCollectionViewCell.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 19.03.2022.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemPink
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
