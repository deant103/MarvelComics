//
//  String+Extension.swift
//  MarvelComics
//
//  Created by Dean Thibault on 3/4/22.
//

import Foundation
import CommonCrypto

extension String {
	
	/// Returns a hash value of self
	var md5: String {
		let data = Data(self.utf8)
		let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
			var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
			CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
			return hash
		}
		return hash.map { String(format: "%02x", $0) }.joined()
	}
	
	/// Returns the string with HTML tags removed
	var removeHTML: String {
	  return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
	}
}
