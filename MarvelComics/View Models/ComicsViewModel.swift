//
//  ComicsViewModel.swift
//  MarvelComics
//
//  Created by Dean Thibault on 3/4/22.
//

import Foundation

/// Callback delegate for use by users of the ComicsViewModel
protocol ComicsViewModelDelegate {
	/// Notifies delegate that the model has changed
	func didUpdateModel(count: Int)
	func handleError(message: String)
}

class ComicsViewModel {
	
	/// The delegte to notify changes
	var delegate: ComicsViewModelDelegate?
	/// The current offset used when requesting data
	var offset: Int = 0
	/// The number of items to include in data requests
	var limit: Int = 20
	/// The data model
	fileprivate var comics: [Comic] = []
	/// The number of items in the data model
	var itemCount: Int {
		return comics.count
	}
	
	/// Creates the URL used when loading comics from the servcie
	/// - Parameter offset: The current offset of items used when requesting data
	/// - Parameter limit: The number of items to request from servcie
	/// - Parameter orderBy: The field to order results by
	/// - Returns: A URL to use when calling the service, nil if unable to create it
	func comicsURL(offset: Int, limit: Int, orderBy: String = "title") -> URL? {
		let authInfo = APIHelper.authInfo()
		let urlString = "\(APIHelper.baseURL)comics?orderBy=\(orderBy)&limit=\(limit)&offset=\(offset)&ts=\(authInfo.timestamp)&apikey=\(authInfo.publicKey)&hash=\(authInfo.hash)"

		
		return URL(string: urlString)
	}
	
	/// Loades the next batch of comics from the service
	/// - Parameter refresh: Indicates current data should be discarded before request new data.
	func load(refresh: Bool) {
		if refresh {
			comics = []
		}
		
		offset = refresh ? 0 : offset + limit
		
		// Create the URL used for calling the comics service. Returns if fails.
		guard let url = comicsURL(offset: offset, limit: limit) else { return }
		
		/// Calls the comics service
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			guard (response as? HTTPURLResponse)?.statusCode == 200 else {
				let statusCode = "\((response as? HTTPURLResponse)?.statusCode ?? 0)"
				self.comics = []
				self.delegate?.handleError(message: "An error occured \(statusCode). Please try again.")
				return
			}
			guard error == nil else {
				self.comics = []
				self.delegate?.handleError(message: "An error occured. Please try again.")
				return
			}
			
			if let data = data {
				do {
					// Parse the response
					let response = try JSONDecoder().decode(Comics.self, from: data)
					// Store the data
					self.comics.append(contentsOf: (response.data?.results ?? []))
					// Set the current offset
					self.offset = self.comics.count
					// Notify the delegate that model has changed
					self.delegate?.didUpdateModel(count: (response.data?.results?.count ?? 0))
				}
				catch {
					print(error)
				}
			}
		}
		task.resume()
	}
	
	/// Returns the title for the given index path
	/// - Parameter for: The index path of requested item
	/// - Returns: The title
	func titleForItem(for indexPath: IndexPath) -> String? {
		guard indexPath.item < comics.count else { return nil }
		
		return comics[indexPath.item].title
	}

	/// Returns the thumbnail image URL for the given index path
	/// - Parameter indexPath: The index path of requested item
	/// - Returns: The URL, nil if URL unavailable
	func thumbnailURLForItem(for indexPath: IndexPath) -> URL? {
		guard indexPath.item < comics.count,
			  let path = comics[indexPath.item].thumbnail?.fullPath else { return nil }

		return URL(string: path)
	}
	
	/// Returns the fomatted issue number for the given index path
	/// - Parameter indexPath: The index path of requested item
	/// - Returns: The formatted issue number
	func issueNumber(for indexPath: IndexPath) -> String? {
		guard indexPath.item < comics.count,
			let issuNumber = comics[indexPath.item].issueNumber else { return nil }

		return "Issue #\(issuNumber)"
	}

	/// Returns the description text for the given index path
	/// - Parameter indexPath: The index path of requested item
	/// - Returns: The description text
	func descriptionString(for indexPath: IndexPath) -> String? {
		guard indexPath.item < comics.count else { return nil }

		return comics[indexPath.item].resultDescription?.removeHTML
	}

	/// Returns the fomatted price(s) text for the given index path. The string will be a newline separated list of the prices, prepended with $, since all prices are in U.S dollars.
	/// Since the price type returned is not a displayable string, it is substitued with a user readable string, if the price type is known. Otherwise the original type is used.
	/// - Parameter indexPath: The index path of requested item
	/// - Returns: The formatted price(s) string.
	func price(for indexPath: IndexPath) -> String {
		guard indexPath.item < comics.count,
			let prices = comics[indexPath.item].prices else { return "" }
		
		var response = ""
		
		for price in prices {
			if let value = price.price {
				let priceString = String(format: "%.2f", value)
				if let type = price.type {
					response.append("\(priceDescription(for: type)): ")
				}
				response.append("$\(priceString)")
				response.append("\n")
			}
		}
		
		return response
	}
	
	/// Returns the price description based on the supplied price type for the given index path. The original price type is returned if no match is found.
	/// - Parameter indexPath: The index path of requested item
	/// - Returns: The formatted price type
	fileprivate func priceDescription(for type: String) -> String {
		switch type {
			case "printPrice": return "Print"
			case "digitalPurchasePrice": return "Digital"
			default: return type
		}
	}
}

