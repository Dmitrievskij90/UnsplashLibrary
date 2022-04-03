//
//  ImageDetailsViewController.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 28.03.2022.
//

import UIKit

class ImageDetailsViewController: UIViewController {
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let image: UIImage

    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = image
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        self.view = view

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        view.addGestureRecognizer(tapGestureRecognizer)

        view.addSubview(imageView)
        imageView.backgroundColor = .gray
        imageView.snp.makeConstraints { make in
            make.leading.trailing.centerY.centerX.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }
    }

    @objc func imageTapped() {
        dismiss(animated: true, completion: nil)
    }
}

