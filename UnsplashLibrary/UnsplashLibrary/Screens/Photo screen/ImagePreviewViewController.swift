//
//  ImagePreviewViewController.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 29.03.2022.
//

import UIKit
import SDWebImage

class ImagePreviewViewController: UIViewController {
    private let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let image: String

    init(image: String) {
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
        imageView.sd_setImage(with: URL(string: image))
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .clear
        self.view = view

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        view.addGestureRecognizer(tapGestureRecognizer)

        view.backgroundColor = .clear
        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.alpha = 1

        view.addSubview(imageView)
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
    }

    override func viewWillLayoutSubviews() {
        blurVisualEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
            make.trailing.equalToSuperview().offset(-30)
            make.leading.equalToSuperview().offset(30)
        }
    }

    @objc func imageTapped() {
        dismiss(animated: true, completion: nil)
    }
}