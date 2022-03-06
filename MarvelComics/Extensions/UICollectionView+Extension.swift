//
//  UICollectionView+Extension.swift
//  MarvelComics
//
//  Created by Dean Thibault on 3/4/22.
//

import Foundation
import UIKit

// UICollectionViewCell extension that adds functionallity
extension UICollectionViewCell {
	
	/// The cell reuse identifier
	static var identifier: String {
		String(describing: self)
	}
	
	/// A nib of the collection view cell
	static var nib: UINib {
		return UINib(nibName: identifier, bundle: nil)
	}
}
