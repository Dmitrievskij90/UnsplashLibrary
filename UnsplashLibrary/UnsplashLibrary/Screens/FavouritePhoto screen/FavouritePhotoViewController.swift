//
//  FavouritePhotoViewController.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 19.03.2022.
//

import UIKit
import CoreData

class FavouritePhotoViewController: UIViewController {
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

    private var fetchResultController: NSFetchedResultsController<FavouritePhoto>!
    private var selectedPhotos = [FavouritePhoto]()
    private let dataManager = DataBaseManager()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.register(FavouritePhotoCell.self, forCellWithReuseIdentifier: FavouritePhotoCell.identifier)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private lazy var deleteBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteBarButtonTapped))
        button.isEnabled = false
        button.tintColor = .black
        return button
    }()

    private lazy var selectBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectBarButtonTapped))
        button.isEnabled = true
        button.tintColor = .darkGray
        return button
    }()

    private lazy var shareBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        button.isEnabled = true
        button.tintColor = .darkGray
        return button
    }()

    // MARK: - Lificycle methods
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillLayoutSubviews() {
        collectionView.frame =  view.frame
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchResultController()
        fetchPhotos()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        refresh()
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        self.view = view

        navigationItem.rightBarButtonItems = [deleteBarButtonItem, selectBarButtonItem]
        navigationItem.leftBarButtonItem = shareBarButtonItem

        view.addSubview(collectionView)
    }

    // MARK: - CoreData methods
    // MARK: -
    private func setupFetchResultController() {
        let fetchRequest: NSFetchRequest<FavouritePhoto> = FavouritePhoto.fetchRequest()
        let sotdDescriptor = NSSortDescriptor(key: #keyPath(FavouritePhoto.dateCreated), ascending: true)
        fetchRequest.sortDescriptors = [sotdDescriptor]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
    }

    private func fetchPhotos() {
        do {
            try fetchResultController.performFetch()
        } catch let error {
            print(error)
        }
        collectionView.reloadData()
    }

    // MARK: - Data manipulation methods
    // MARK: -
    private func refresh() {
        resetSeletedPhotos()
        deleteBarButtonItem.isEnabled = false
        selectBarButtonItem.title = "Select"
    }

    private func delete() {
        dataManager.delete(photos: selectedPhotos)
        refresh()
    }

    private func resetSeletedPhotos() {
        selectedPhotos.removeAll()
        collectionView.reloadData()

      fetchResultController.fetchedObjects?.indices.forEach { fetchResultController.fetchedObjects?[$0].isSelected = false }
    }

    private func getSelectedImages() -> [UIImage] {
        var images = [UIImage]()
        for image in selectedPhotos {
            if let data = image.photo as Data?, let image = UIImage(data: data) {
                    images.append(image)
            }
        }
        return images
    }

    // MARK: - Actions
    // MARK: -
    @objc private func deleteBarButtonTapped() {
        let alertController = UIAlertController(title: "Delete photo", message: "\(selecetedPhotoCountDescription) will be delete", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Delete", style: .default) { _ in
            self.delete()
        }
        let cancelAction = UIAlertAction(title: "Undo", style: .destructive) { _ in
            self.refresh()
        }
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

    @objc private func selectBarButtonTapped() {
        if selectBarButtonItem.title == "Select" {
            selectBarButtonItem.title = "Cancel"
        } else {
            selectBarButtonItem.title = "Select"
            resetSeletedPhotos()
        }
        deleteBarButtonItem.isEnabled.toggle()
        deleteBarButtonItem.tintColor = .init(hex: 0xC74B50)
    }

    @objc func shareButtonTapped(sender: UIBarButtonItem) {
        let shareController = UIActivityViewController(activityItems: getSelectedImages(), applicationActivities: nil)
        shareController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.refresh()
            }
        }
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true, completion: nil)
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
//MARK: -
extension FavouritePhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = fetchResultController.sections?[section]
        return sectionInfo?.numberOfObjects ?? 0
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouritePhotoCell.identifier, for: indexPath) as? FavouritePhotoCell else {
            return UICollectionViewCell()
        }
        let photo = fetchResultController.object(at: indexPath)
        cell.data = photo
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 3) - 10, height: (view.frame.width / 3))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 5, bottom: 0, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = fetchResultController.object(at: indexPath)
        if deleteBarButtonItem.isEnabled {
            selectedPhotos.update(photo)
            photo.isSelected.toggle()
            collectionView.reloadItems(at: [indexPath])
        }
    }
}

//MARK: - NSFetchedResultsControllerDelegate
//MARK: -
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
