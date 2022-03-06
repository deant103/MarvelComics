//
//  MarvelComicsTests.swift
//  MarvelComicsTests
//
//  Created by Dean Thibault on 3/4/22.
//

import XCTest
@testable import MarvelComics

class MarvelComicsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testImageViewExtension() throws {
        let imageView = UIImageView()
		let urlString = "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg"
		
		guard let url = URL(string: urlString) else {
			XCTFail("Invalid URL: \(urlString) ")
			return
		}
		
		imageView.setImage(from: url)
		
		/// Wait for image to be loaded
		let exp = expectation(description: "Test after 3 seconds")
		let result = XCTWaiter.wait(for: [exp], timeout: 3.0)
		if result == XCTWaiter.Result.timedOut {
			XCTAssertNotNil(imageView.image)
		}
		else {
			XCTFail("Delay Interrupted")
		}
    }

	func testCollectionViewExtension() throws {
		
		// Verify reuse identifier is correct
		XCTAssertEqual(MainComicCollectionViewCell.identifier, "MainComicCollectionViewCell")
		
		// Verify nib loaded
		XCTAssertNotNil(MainComicCollectionViewCell.nib)
	}

}
