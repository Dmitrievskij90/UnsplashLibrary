//
//  LaunchScreenViewController.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 13.04.2022.
//

import UIKit

class LaunchScreenViewController: UIViewController {

   private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "FIND YOUR INSPIRATION"
        label.textColor = .white
        label.font = UIFont(name: "GillSans-Light", size: 15)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(imageView)
        view.addSubview(label)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(300)
        }

        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
            make.height.equalTo(80)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.animate()
        }
    }

   private func animate() {
        UIView.animate(withDuration: 1.0) {
            self.imageView.alpha = 0
            self.label.alpha = 0
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let destinationVC = MainTabBarController()
                destinationVC.modalTransitionStyle = .crossDissolve
                destinationVC.modalPresentationStyle = .fullScreen
                self.present(destinationVC, animated: true)
            }
        }
    }
}
