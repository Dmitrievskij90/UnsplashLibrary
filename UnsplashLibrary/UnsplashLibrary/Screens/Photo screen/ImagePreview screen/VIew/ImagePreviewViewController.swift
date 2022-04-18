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
    private lazy var presenter = ImagePreviewPresenter(view: self, dataManager: DataBaseManager())

     var imageView: UIImageView = {
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
        button.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

     lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [shareButton, bottomView, favouriteButton])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.layer.cornerRadius = 15
        stackView.clipsToBounds = true
        return stackView
    }()

    let imageURL: ImagePreviewModel

    init(imageURL: ImagePreviewModel) {
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.sd_setImage(with: URL(string: imageURL.name))
        remakeConstraints()
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
    }

    @objc private func imageTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func shareButtonTapped() {
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

    @objc private func favouriteButtonTapped() {
        presenter.saveImage(with: imageView)
    }
}

extension ImagePreviewViewController: ImagePreviewPresenterProtocol {
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}
