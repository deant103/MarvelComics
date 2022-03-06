//
//  ComicViewController.swift
//  MarvelComics
//
//  Created by Dean Thibault on 3/5/22.
//

import UIKit

class ComicViewController: UIViewController {
	
	@IBOutlet var mainImageView: UIImageView!
	@IBOutlet var backgroundView: UIView! {
		didSet {
			backgroundView.layer.cornerRadius = 10.0
		}
	}
	@IBOutlet var backgroundTapGestureRecognizer: UITapGestureRecognizer!
	@IBOutlet var backgroundViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet var scrollView: UIScrollView!
	@IBOutlet var stackView: UIStackView!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var issueNumberLabel: UILabel!
	@IBOutlet var descriptionLabel: UILabel!
	@IBOutlet var priceLabel: UILabel!
	
	var indexPath: IndexPath?
	var comicsViewModel = ComicsViewModel()
	fileprivate var isCollapsed = false

    override func viewDidLoad() {
        super.viewDidLoad()

		setupView()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(false, animated: animated)
		backgroundViewHeightConstraint.constant = 0
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
			self.animateShowBackground()
		}
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		
		backgroundViewHeightConstraint.constant = backgroundHeight(size: size)
	}
	
	fileprivate func backgroundHeight(size: CGSize) -> CGFloat {
		if isCollapsed {
			return 125
		}
		else {
			return (size.height * 0.66) + 20
		}
	}
	
	@IBAction func backgroundTapped(_ sender: Any) {
		
		var labels: [UILabel] = [issueNumberLabel, descriptionLabel, priceLabel]
		labels = labels.filter { $0.text != nil && !($0.text?.isEmpty ?? true) }
		
		for label in labels {
			DispatchQueue.main.async {
				label.isHidden = self.isCollapsed
			}
		}

		isCollapsed = !isCollapsed
		backgroundViewHeightConstraint.constant = backgroundHeight(size: view.frame.size)

		UIView.animate(withDuration: 0.25, animations: {
			self.view.layoutIfNeeded()
		})
	}
	
	fileprivate func setupView() {
		
		if let indexPath = indexPath,
			let url =  comicsViewModel.thumbnailURLForItem(for: indexPath) {
			mainImageView.setImage(from: url)
			titleLabel.text = comicsViewModel.titleForItem(for: indexPath)
			issueNumberLabel.text = comicsViewModel.issueNumber(for: indexPath)
			descriptionLabel.text = comicsViewModel.descriptionString(for: indexPath)
			priceLabel.text = comicsViewModel.price(for: indexPath)
		}
	}
	
	fileprivate func animateShowBackground() {
		backgroundViewHeightConstraint.constant = backgroundHeight(size: view.frame.size)

		UIView.animate(withDuration: 0.5, animations: {
			self.view.layoutIfNeeded()
		}, completion: { complete in
			if complete {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
					self.animateLabels()
				}
			}
		})
	}

	fileprivate func animateLabels() {
		var labels: [UILabel] = [titleLabel, issueNumberLabel, descriptionLabel, priceLabel]
		labels = labels.filter { $0.text != nil && !($0.text?.isEmpty ?? true) }
		
		var delay = 0.35
		for label in labels {
			label.isHidden = false
			UIView.animate(withDuration: 0.25, delay: delay, animations: {
				label.alpha = 1
				self.view.layoutIfNeeded()
			})

			delay += 0.35
		}
	}
}
