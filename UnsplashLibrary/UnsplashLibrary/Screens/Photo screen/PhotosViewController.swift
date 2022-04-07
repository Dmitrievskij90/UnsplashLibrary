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

    private(set) var selectedImage: UIImageView!
    private let animator = Animator()
    private var timer: Timer?
    private var photos = [PhotoModel]()
    private var selectedPhotos = [UIImage]()
    private let dataManager = DataBaseManager()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.backgroundColor = UIColor.black
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private lazy var acrivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .lightGray
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var saveBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBarButtonTapped))
        button.isEnabled = false
        button.tintColor = .white
        return button
    }()

    private let searhController = UISearchController(searchResultsController: nil)
    private let networkService = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGestureRecognizer.minimumPressDuration = 0.3
        collectionView.addGestureRecognizer(longPressGestureRecognizer)

    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .black
        self.view = view

        view.addSubview(collectionView)
        view.addSubview(acrivityIndicator)
        setupSearchBar()

        navigationItem.rightBarButtonItem = saveBarButtonItem
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
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
        searhController.searchBar.searchTextField.textColor = .white
        searhController.searchBar.tintColor = .white
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

    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .ended {
            return
        }

        let point = gesture.location(in: self.collectionView)
        if let indexPath = self.collectionView.indexPathForItem(at: point) {
            guard let cell = self.collectionView.cellForItem(at: indexPath) as?  PhotoCollectionViewCell else { return }
            self.selectedImage = cell.imageView
            let photo = photos[indexPath.item].imageURL

            HapticsManager.shared.vibrate(for: .success)

            let destinationVC = ImagePreviewViewController(image: photo)
            destinationVC.transitioningDelegate = self
            present(destinationVC, animated: true, completion: nil)
        } else {
            print("couldn't find index path")
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
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
        let orientation = UIDevice.current.orientation
        if orientation.isLandscape {
            return CGSize(width: (view.frame.width / 5) - 10, height: (view.frame.width / 5))
        } else {
            return CGSize(width: (view.frame.width / 2) - 10, height: (view.frame.width / 2))
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 5, bottom: 0, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticsManager.shared.selection()
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        guard let image = cell.imageView.image else { return }
        selectedPhotos.update(image)
        undatesaveBarButton()

        photos[indexPath.item].isSelected.toggle()
        collectionView.reloadItems(at: [indexPath])
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

extension PhotosViewController: UIViewControllerTransitioningDelegate {
    func animationController( forPresented _: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.originFrame = selectedImage.superview!.convert(selectedImage.frame, to: nil)
        animator.presenting = true
        return animator
    }

    func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = false
        return animator
    }
}

