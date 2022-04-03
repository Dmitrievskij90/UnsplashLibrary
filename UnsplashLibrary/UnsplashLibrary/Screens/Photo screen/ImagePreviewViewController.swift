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

    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var shareButton: ActivityControllerButton = {
        let button = ActivityControllerButton(type: .system)
        button.configureButton(text: "Share", imageName: "square.and.arrow.up")
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var favouriteButton: ActivityControllerButton = {
        let button = ActivityControllerButton(type: .system)
        button.configureButton(text: "Favourite", imageName: "heart")
        return button
    }()

    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [shareButton, bottomView, favouriteButton])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.layer.cornerRadius = 15
        stackView.clipsToBounds = true
        return stackView
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
        view.addSubview(stackView)
    }

    override func viewWillLayoutSubviews() {
        blurVisualEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-20)
            make.height.equalToSuperview().dividedBy(2)
            make.trailing.equalToSuperview().offset(-30)
            make.leading.equalToSuperview().offset(30)
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

    @objc private func imageTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func shareButtonTapped(sender: UIButton) {
        guard let image = imageView.image else { return }
        let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        shareController.completionWithItemsHandler = { _, success, _, error in
            if let error = error {
                print("Finished with error:", error)
            }

            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(shareController, animated: true, completion: nil)
    }
}
