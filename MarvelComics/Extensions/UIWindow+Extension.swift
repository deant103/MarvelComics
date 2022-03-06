//
//  UIWindow+Extension.swift
//  MarvelComics
//
//  Created by Dean Thibault on 3/5/22.
//

import Foundation
import UIKit

extension UIWindow {
	
	/// Returns whether the current device orientation is landscape
	static var isLandscape: Bool {
		guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else {
			return false
		}
		
		return orientation.isLandscape
	}
}
