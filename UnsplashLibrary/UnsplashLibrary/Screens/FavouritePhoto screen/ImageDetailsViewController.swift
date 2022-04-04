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

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        view.addGestureRecognizer(tapGestureRecognizer)

        view.addSubview(imageZoomView)
    }

    override func viewWillLayoutSubviews() {
        setupImageScrollView()
    }

   private func setupImageScrollView() {
        imageZoomView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc private func imageTapped() {
        //        dismiss(animated: true, completion: nil)
    }
}
