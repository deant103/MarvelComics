//
//  File.swift
//  MarvelComics
//
//  Created by Dean Thibault on 3/4/22.
//

import Foundation

/// Provides  functionality that aids in connecting to the Web Service.
class APIHelper {
	/// The API public key
	static let publicKey = "062d61c602b5a61fbf9f4020e90a0abd"
	/// The API private key
	static let privateKey = "f6f64bcb8bbc10dcfc1c661f8d90984c09782011"
	/// The base URL used to generate URLs for API calls
	static let baseURL = "https://gateway.marvel.com:443/v1/public/"
	
	/// Returns the authorization information required to authorize API calls with the service
	///  - Returns: Returns a tuple containing the timestamp, the api public key and a hash string created using the timestamp, public and private keys.
	static func authInfo() -> (timestamp: String, publicKey: String, hash: String) {
		let timestamp = "\(Date().timeIntervalSince1970)"
		let hash = "\(timestamp)\(APIHelper.privateKey)\(APIHelper.publicKey)".md5
		return (timestamp, APIHelper.publicKey, hash)
	}
}
