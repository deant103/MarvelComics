//
//  MarvelComicsViewModelTests.swift
//  MarvelComicsTests
//
//  Created by Dean Thibault on 3/5/22.
//

import XCTest
@testable import MarvelComics

class MarvelComicsViewModelTests: XCTestCase {

	let expectation = XCTestExpectation(description: "Download apple.com home page")

	/// Tests that view model has loaded data. This should be updated to test using mock data.
	func testExample() throws {

		let viewModel = ComicsViewModel()
		viewModel.delegate = self
		viewModel.load(refresh: true)
		
		wait(for: [expectation], timeout: 10.0)
	}
}

// Implement the delegate to test the completion
extension MarvelComicsViewModelTests: ComicsViewModelDelegate {
	func didUpdateModel(count: Int) {
		print("did update")
		XCTAssertTrue(count > 0)
		expectation.fulfill()
	}
}
