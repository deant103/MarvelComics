//
//  MainComicCollectionViewCell.swift
//  MarvelComics
//
//  Created by Dean Thibault on 3/4/22.
//

import UIKit

/// The collection view cell used in the main view
class MainComicCollectionViewCell: UICollectionViewCell {
	
	/// The main image view
	@IBOutlet var imageView: UIImageView! {
		didSet {
			imageView.layer.cornerRadius = 5
		}
	}
	/// The title label
	@IBOutlet var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
