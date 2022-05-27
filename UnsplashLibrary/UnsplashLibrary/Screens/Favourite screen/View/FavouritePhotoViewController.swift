//
//  FavouritePhotoViewController.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 19.03.2022.
//

import UIKit
import CoreData

class FavouritePhotoViewController: UIViewController {
    var selectedImage: UIImageView!
    var presenter: FavouritePhotoPresenterProtocol!

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.register(FavouritePhotoCell.self, forCellWithReuseIdentifier: FavouritePhotoCell.identifier)
        collectionView.backgroundColor = UIColor.black
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private lazy var deleteBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteBarButtonTapped))
        button.isEnabled = false
        button.tintColor = .white
        return button
    }()

    private lazy var selectBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectBarButtonTapped))
        button.isEnabled = true
        button.tintColor = .white
        return button
    }()

    private lazy var shareBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        button.isEnabled = false
        button.tintColor = .white
        return button
    }()

    // MARK: - Lificycle methods
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        FavouriteScreenWireframe.createFavouriteScreenModule(with: self)
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .black
        self.view = view

        navigationItem.rightBarButtonItems = [deleteBarButtonItem, selectBarButtonItem]
        navigationItem.leftBarButtonItem = shareBarButtonItem

        view.addSubview(collectionView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.frame
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillApperar()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        refresh()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }

    // MARK: - Data manipulation methods
    // MARK: -

    private func getSelectedImages() -> [UIImage] {
        var images = [UIImage]()
        for image in presenter.selectedPhotos {
            if let data = image.photo as Data?, let image = UIImage(data: data) {
                images.append(image)
            }
        }
        return images
    }

    // MARK: - Actions
    // MARK: -
    @objc private func deleteBarButtonTapped() {
        if !presenter.selectedPhotos.isEmpty {
            let alertController = createAlertController(type: .delete, array: presenter.selectedPhotos)
            let addAction = UIAlertAction(title: "Delete", style: .default) { _ in
                self.presenter.deleteBarButtonTapped()
            }
            let cancelAction = UIAlertAction(title: "Undo", style: .destructive) { _ in
                self.refresh()
            }
            alertController.addAction(addAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }
    }

    @objc private func selectBarButtonTapped() {
        if selectBarButtonItem.title == "Select" {
            selectBarButtonItem.title = "Cancel"
        } else {
            selectBarButtonItem.title = "Select"
            self.presenter.selectBarButtonTapped()
        }
        deleteBarButtonItem.isEnabled.toggle()
        deleteBarButtonItem.tintColor = .init(hex: 0xF900BF)
        shareBarButtonItem.isEnabled.toggle()
        shareBarButtonItem.tintColor = .init(hex: 0xFFF56D)
    }

    @objc func shareButtonTapped(sender: UIBarButtonItem) {
        let shareController = UIActivityViewController(activityItems: getSelectedImages(), applicationActivities: nil)
        shareController.completionWithItemsHandler = { _, success, _, _ in
            if success {
                self.refresh()
            }
        }
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
// MARK: -
extension FavouritePhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = presenter.fetchResultController.sections?[section]
        return sectionInfo?.numberOfObjects ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: FavouritePhotoCell.self, for: indexPath)
        let photo = presenter.fetchResultController.object(at: indexPath)
        cell.data = photo
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
            return CGSize(width: (view.frame.width / 3) - 10, height: (view.frame.width / 3))
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 5, bottom: 0, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticsManager.shared.selection()
        let photo = presenter.fetchResultController.object(at: indexPath)
        if deleteBarButtonItem.isEnabled {
            presenter.selectedPhotos.update(photo)
            photo.isSelected.toggle()
            collectionView.reloadItems(at: [indexPath])
        } else {
            guard let selectedCell = collectionView.cellForItem(at: indexPath) as? FavouritePhotoCell else { return }
            self.selectedImage = selectedCell.imageView
            presenter.showFullPhoto(with: photo, from: self)
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
// MARK: -
extension FavouritePhotoViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                collectionView.deleteItems(at: [indexPath])
            }
        default:
            break
        }
    }
}

extension FavouritePhotoViewController: FavouritePhotoViewProtocol {
    func reloadData() {
        collectionView.reloadData()
    }

    func refresh() {
        presenter.selectBarButtonTapped()
        deleteBarButtonItem.isEnabled = false
        shareBarButtonItem.isEnabled = false
        selectBarButtonItem.title = "Select"
    }
}
