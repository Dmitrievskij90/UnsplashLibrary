//
//  ViewController.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 19.03.2022.
//

import UIKit

class PhotosViewController: UIViewController {
    private var timer: Timer?
    private var photos = [PhotoModel]()

//    private var selected = [String]()
    private var selectedPhotos = [UIImage]()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private let acrivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .darkGray
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var saveBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBarButtonTapped))
        button.isEnabled = true
        button.tintColor = .black
        return button
    }()

    private let searhController = UISearchController(searchResultsController: nil)
    private let networkService = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        self.view = view

        view.addSubview(collectionView)
        view.addSubview(acrivityIndicator)
        setupSearchBar()

        navigationItem.rightBarButtonItem = saveBarButtonItem
    }

    override func viewWillLayoutSubviews() {
        collectionView.frame =  view.frame

        acrivityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searhController
        navigationItem.hidesSearchBarWhenScrolling = false
        searhController.hidesNavigationBarDuringPresentation = false
        searhController.obscuresBackgroundDuringPresentation = false
        searhController.searchBar.searchTextField.textColor = .black
        searhController.searchBar.tintColor = .black
        searhController.searchBar.delegate = self
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 10 {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
                self.navigationController?.navigationBar.isHidden = true
            }
        } else if scrollView.contentOffset.y < 10 {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
                self.navigationController?.navigationBar.isHidden = false
            }
        }
    }

    @objc private func saveBarButtonTapped() {
    }
}

extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.data = photos[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 2) - 10, height: (view.frame.width / 2))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 5, bottom: 0, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let imageURL = photos[indexPath.item].imageURL
//
//        if selected.contains(imageURL) {
//            let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
//            guard let image = cell.data?.imageURL else { return }
//            if let index = selected.firstIndex(of: image){
//                selected.remove(at: index)
//            }
//        } else {
//            selected.append(imageURL)
//        }

        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        guard let image = cell.imageView.image else { return }

        if selectedPhotos.contains(image) {
            if let index = selectedPhotos.firstIndex(of: image){
                selectedPhotos.remove(at: index)
            }
        } else {
            selectedPhotos.append(image)
        }

//        print(selected.count)
//        print(selected)

        let hasFavorited = photos[indexPath.item].isSelected
        photos[indexPath.item].isSelected = !hasFavorited
        self.collectionView.reloadItems(at: [indexPath])
    }
}

extension PhotosViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        acrivityIndicator.startAnimating()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkService.searchPhoto(searchTerm: searchText) { [weak self] result, error in
                if let err = error {
                    print("we hawe probler", err)
                }

                if let saveData = result?.results {
                    self?.photos = saveData.compactMap { PhotoModel(imageURL: $0.urls.regular)}
                    DispatchQueue.main.async {
                        self?.acrivityIndicator.stopAnimating()
                        self?.collectionView.reloadData()
                    }
                }
            }
        })
    }
}

