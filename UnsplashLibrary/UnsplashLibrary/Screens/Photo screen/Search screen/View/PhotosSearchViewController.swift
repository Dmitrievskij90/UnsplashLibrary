//
//  ViewController.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 19.03.2022.
//

import UIKit
import CoreData

class PhotosSearchViewController: UIViewController {
    var selectedImage: UIImageView!
    private var photos = [PhotoModel]()
    private var selectedPhotos = [UIImage]()
    private lazy var presenter = PhotoSearchPresenter(view: self, dataManager: DataBaseManager(), networkService: NetworkService())
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.register(PhotoSearchCollectionViewCell.self, forCellWithReuseIdentifier: PhotoSearchCollectionViewCell.identifier)
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
    
    // MARK: - Lificycle methods
    // MARK: -
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    // MARK: - setup UI methods
    // MARK: -
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
    
    // MARK: - Actions
    // MARK: -
    @objc private func saveBarButtonTapped() {
        let alertController = createAlertController(type: .add, array: selectedPhotos)
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            self.presenter.savePhotos(images: self.selectedPhotos)
        }
        let cancelAction = UIAlertAction(title: "Undo", style: .destructive) { _ in
            self.refresh()
        }
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer!) {
        if gesture.state != .ended {
            return
        }
        let point = gesture.location(in: self.collectionView)
        
        guard let indexPath = self.collectionView.indexPathForItem(at: point),
              let cell = self.collectionView.cellForItem(at: indexPath) as?  PhotoSearchCollectionViewCell else { return }
        self.selectedImage = cell.imageView
        let photo = photos[indexPath.item].imageURL
        
        presentImagePreviewController(with: photo)
    }
    
    private func presentImagePreviewController(with image: String) {
        HapticsManager.shared.vibrate(for: .success)
        let imageName = ImagePreviewModel(name: image)
        let destinationVC = ImagePreviewViewController(imageURL: imageName)
        destinationVC.transitioningDelegate = self
        present(destinationVC, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
// MARK: -
extension PhotosSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PhotoSearchCollectionViewCell.self, for: indexPath)
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
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoSearchCollectionViewCell,
              let image = cell.imageView.image else { return }
        selectedPhotos.update(image)
        undatesaveBarButton()
        
        photos[indexPath.item].isSelected.toggle()
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - UISearchBarDelegate methods
// MARK: -
extension PhotosSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        acrivityIndicator.startAnimating()
        presenter.searchPhotos(with: searchText)
        collectionView.reloadData()

        if searchText.isEmpty {
            presenter.cancelButtonPressed()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.photos.removeAll()
        collectionView.reloadData()
        presenter.cancelButtonPressed()
    }
}

// MARK: - UIScrollViewDelegate methods
// MARK: -
extension PhotosSearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (collectionView.contentSize.height - 100 - scrollView.frame.size.height) {
            presenter.searchNextPhotos()
        }
    }
}

// MARK: - PhotoSearchPresenterProtocol methods
// MARK: -
extension PhotosSearchViewController: PhotoSearchPresenterProtocol {
    func addPhotos(photos: [PhotoModel]) {
        self.photos.append(contentsOf: photos)
        collectionView.reloadData()
    }

    func setPhotos(photos: [PhotoModel]) {
        self.photos = photos
        collectionView.reloadData()
        acrivityIndicator.stopAnimating()
    }

    func refresh() {
        selectedPhotos.removeAll()
        photos.indices.forEach { photos[$0].isSelected = false }
        collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        collectionView.reloadData()
        undatesaveBarButton()
    }
}
