//
//  ViewController.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 19.03.2022.
//

import UIKit
import CoreData

class PhotosViewController: UIViewController {
    private var selecetedPhotoCountDescription: String {
        switch selectedPhotos.count {
        case 1:
            return " \(selectedPhotos.count) photo"
        case (let count) where count > 1:
            return " \(selectedPhotos.count) photos"
        default:
            return " \(selectedPhotos.count) photo"
        }
    }

    private var timer: Timer?
    private var photos = [PhotoModel]()
    private var selectedPhotos = [UIImage]()
    private let dataManager = DataBaseManager()

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

    private lazy var acrivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .darkGray
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var saveBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBarButtonTapped))
        button.isEnabled = false
        button.tintColor = .black
        return button
    }()

    private let searhController = UISearchController(searchResultsController: nil)
    private let networkService = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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

    private func undatesaveBarButton() {
        saveBarButtonItem.isEnabled = selectedPhotos.count > 0
    }

    private func refresh() {
        selectedPhotos.removeAll()
        photos.indices.forEach { photos[$0].isSelected = false }
        collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        collectionView.reloadData()
        undatesaveBarButton()
    }

    @objc private func saveBarButtonTapped() {
        let alertController = UIAlertController(title: "Add to favorites?", message: "\(selecetedPhotoCountDescription) will be added", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            self.savePhotos()
        }
        let cancelAction = UIAlertAction(title: "Dismiss", style: .destructive) { _ in
            self.refresh()
        }
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

    private func savePhotos() {
        dataManager.save(images: selectedPhotos)
        refresh()
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
//        refresh()
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        guard let image = cell.imageView.image else { return }

        if selectedPhotos.contains(image) {
            if let index = selectedPhotos.firstIndex(of: image){
                selectedPhotos.remove(at: index)
            }
        } else {
            selectedPhotos.append(image)
        }

        self.undatesaveBarButton()

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
                        self?.refresh()
                    }
                }
            }
        })
    }
}

