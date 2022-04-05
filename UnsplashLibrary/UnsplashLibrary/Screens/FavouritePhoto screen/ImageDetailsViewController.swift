//
//  ImageDetailsViewController.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 28.03.2022.
//

import UIKit

class ImageDetailsViewController: UIViewController {
    lazy var imageZoomView: ImageZoomView = {
        let imageView = ImageZoomView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()

    private let image: UIImage

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
        self.imageZoomView.setImage(image: image)
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .black
        self.view = view

        view.addSubview(imageZoomView)
        view.addSubview(closeButton)
    }

    override func viewWillLayoutSubviews() {
        setupSubviews()
    }

    private func setupSubviews() {
        imageZoomView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(5)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-5)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
    }

    @objc private func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
}
