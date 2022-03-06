//
//  UIImageView+Extension.swift
//  MarvelComics
//
//  Created by Dean Thibault on 3/4/22.
//

import Foundation
import UIKit

// UIImageView extension that provides additional functionality. 
extension UIImageView {
	
	/// Downloads an image from the given URL and displays it in the UIImageView
	func setImage(from url: URL) {
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let data = data {
				DispatchQueue.main.async {
					self.image = UIImage(data: data)
				}
			}
		}
		task.resume()
	}
}
