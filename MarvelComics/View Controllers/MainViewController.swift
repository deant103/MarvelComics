//
//  MainViewController.swift
//  MarvelComics
//
//  Created by Dean Thibault on 3/4/22.
//

import UIKit
import Network

class MainViewController: UIViewController {
	
	/// The main collection view for displaying comic information
	@IBOutlet var collectionView: UICollectionView! {
		didSet {
			collectionView.register(MainComicCollectionViewCell.nib, forCellWithReuseIdentifier: MainComicCollectionViewCell.identifier)
			collectionView.refreshControl = refreshControl
		}
	}
	
	///  The refresh control
	let refreshControl = UIRefreshControl()
	/// The view model from
	fileprivate var comicsViewModel = ComicsViewModel()
	/// The number of rows to display horizontally
	fileprivate var rowSize: CGFloat = 3
	/// Flag to indicate data is being loaded
	fileprivate var isLoading = false
	/// Flag to indicate if empty table message should be displayed
	fileprivate var shouldShowEmptyTableMessage = false
	
    override func viewDidLoad() {
        super.viewDidLoad()

		refreshControl.addTarget(self, action: #selector(refreshComicsData(_:)), for: .valueChanged)
		refreshControl.tintColor = .white
		comicsViewModel.delegate = self
		comicsViewModel.load(refresh: true)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		navigationController?.setNavigationBarHidden(true, animated: animated)
		setRowSize()
		if isLoading {
			showRefreshControl()
		}
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
		setRowSize()
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.collectionView.collectionViewLayout.invalidateLayout()
		}
	}
	
	/// Show the refresh control
	fileprivate func showRefreshControl() {
		DispatchQueue.main.async {
			self.refreshControl.beginRefreshing()
		}
	}

	/// Hide the refresh control
	fileprivate func hideRefreshControl() {
		DispatchQueue.main.async {
			self.refreshControl.endRefreshing()
		}
	}

	///  Set the horizontal row size based on current device orientation.
	fileprivate func setRowSize() {
		rowSize = UIWindow.isLandscape ? 4 : 3
	}
	
	/// Called by the refresh control
	@objc private func refreshComicsData(_ sender: Any) {
		comicsViewModel.load(refresh: true)
	}
	
	fileprivate func showError(message: String) {
		let alertController = UIAlertController(title: "An Error Occurred", message: message, preferredStyle: .alert)
		let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
		alertController.addAction(action)
		DispatchQueue.main.async {
			self.present(alertController, animated: true, completion: nil)
		}
	}
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		// Calculate the cell size based on the number of items to display horizontally,
		// given the insets defined in the collection view layout, maintaining the aspect ratio of images
		let interimSpacing: CGFloat = CGFloat((collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0)
		let sectionInset = (collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset
		let inset: CGFloat = (sectionInset?.left ?? 0) + (sectionInset?.right ?? 0)
		let spacing: CGFloat = ((rowSize - 1) * interimSpacing) + inset
		let width: CGFloat = (view.frame.size.width - spacing) / rowSize
		let height: CGFloat = (width * 850 / 553) + 56.5
		
		return CGSize(width: width, height: height)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let viewController = ComicViewController()
		viewController.comicsViewModel = comicsViewModel
		viewController.indexPath = indexPath
		navigationController?.pushViewController(viewController, animated: true)
	}
}

extension MainViewController: UICollectionViewDataSource {
	
	fileprivate func displayEmptyMessage() {
		let label = UILabel(frame: collectionView.frame)
		label.backgroundColor = .clear
		label.textColor = .white
		label.textAlignment = .center
		label.text = "Nothing to display. Pull to refresh."
		collectionView.backgroundView = label
	}
	
	fileprivate func removeEmptyMessage () {
		collectionView.backgroundView = nil
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let count = comicsViewModel.itemCount
		count == 0 && shouldShowEmptyTableMessage ? displayEmptyMessage() : removeEmptyMessage()

		return count
	}
	
	/// When approacing the end of current items while scrolling, will request the view model to load more items
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		if indexPath.item == comicsViewModel.itemCount - 10 && !isLoading {
			isLoading = true
			comicsViewModel.load(refresh: false)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainComicCollectionViewCell.identifier, for: indexPath) as? MainComicCollectionViewCell else { return UICollectionViewCell() }
		
		// Retreive item information from view model and display in cell
		cell.label.text = comicsViewModel.titleForItem(for: indexPath)
		cell.imageView.image = nil
		if let url = comicsViewModel.thumbnailURLForItem(for: indexPath) {
			cell.imageView.setImage(from: url)
		}
		
		return cell
	}
}

/// The view controller implements this delegate extension in order to be nofified when the view model has
/// loaded data
extension MainViewController: ComicsViewModelDelegate {
	
	func didUpdateModel(count: Int) {
		hideRefreshControl()
		isLoading = false
		shouldShowEmptyTableMessage = true
		DispatchQueue.main.async {
			/// create index paths for the new items and append them to collection view
			let total = self.comicsViewModel.itemCount
			let currentCount = self.comicsViewModel.itemCount - count
			let indexPaths = Array(currentCount..<total).map { IndexPath(item: $0, section: 0) }
			self.collectionView.insertItems(at: indexPaths)
		}
	}
	
	func handleError(message: String) {
		hideRefreshControl()
		shouldShowEmptyTableMessage = true
		showError(message: message)
		DispatchQueue.main.async {
			self.collectionView.reloadData()
		}
	}
}
