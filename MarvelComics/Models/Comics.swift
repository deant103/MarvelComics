//
//  Comics.swift
//  MarvelComics
//
//  Created by Dean Thibault on 3/4/22.
//

import Foundation

// These are the models used contain the comic information retrieved from the service. 

// MARK: - Comics
struct Comics: Codable {
	let code: Int?
	let status, copyright, attributionText, attributionHTML: String?
	let etag: String?
	let data: ComicsDataContainer?
}

// MARK: - ComicsDataContainer
struct ComicsDataContainer: Codable {
	let offset, limit, total, count: Int?
	let results: [Comic]?
}

// MARK: - Comic
struct Comic: Codable {
	let id, digitalID: Int?
	let title: String?
	let issueNumber: Int?
	let variantDescription: String?
	let resultDescription: String?
	let modified: String?
	let isbn, upc, diamondCode, ean: String?
	let issn, format: String?
	let pageCount: Int?
	let textObjects: [TextObject]?
	let resourceURI: String?
	let urls: [URLElement]?
	let series: Series
	let variants, collections, collectedIssues: [ComicSummary]?
	let dates: [DateElement]?
	let prices: [Price]?
	let thumbnail: Image?
	let images: [Image]?
	let creators: Creators?
	let characters: Characters?
	let stories: StoryList?
	let events: Characters?

	enum CodingKeys: String, CodingKey {
		case id
		case digitalID = "digitalId"
		case title, issueNumber, variantDescription
		case resultDescription = "description"
		case modified, isbn, upc, diamondCode, ean, issn, format, pageCount, textObjects, resourceURI, urls, series, variants, collections, collectedIssues, dates, prices, thumbnail, images, creators, characters, stories, events
	}
}

// MARK: - Characters
struct Characters: Codable {
	let available: Int?
	let collectionURI: String?
	let items: [Series]?
//	let returned: Int
}

// MARK: - Series
struct Series: Codable {
	let resourceURI: String?
	let name: String?
}

// MARK: - Creators
struct Creators: Codable {
	let available: Int?
	let collectionURI: String?
	let items: [CreatorsItem]?
	let returned: Int?
}

// MARK: - CreatorsItem
struct CreatorsItem: Codable {
	let resourceURI: String?
	let name, role: String?
}

// MARK: - DateElement
struct DateElement: Codable {
	let type: String?
	let date: String?
}

// MARK: - Image
struct Image: Codable {
	let path: String
	let imageExtension: String
	
	var fullPath: String {
		return "\(path).\(imageExtension)"
	}

	enum CodingKeys: String, CodingKey {
		case path
		case imageExtension = "extension"
	}
}

// MARK: - Price
struct Price: Codable {
	let type: String?
	let price: Double?
}

// MARK: - StoryList
struct StoryList: Codable {
	let available: Int?
	let collectionURI: String?
	let items: [StorySummary]?
	let returned: Int?
}

// MARK: - StorySummary
struct StorySummary: Codable {
	let resourceURI: String?
	let name, type: String?
}

// MARK: - TextObject
struct TextObject: Codable {
	let type: String?
	let language: String?
	let text: String?
}

// MARK: - URLElement
struct URLElement: Codable {
	let type: String?
	let url: String?
}

// MARK: - ComicSummary
struct ComicSummary: Codable {
	let resourceURI: String?
	let name: String?
}

