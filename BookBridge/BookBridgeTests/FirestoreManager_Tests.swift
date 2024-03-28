//
//  FirestoreManager_Tests.swift
//  BookBridgeTests
//
//  Created by 이민호 on 2/21/24.
//

import XCTest
@testable import BookBridge

final class FirestoreManager_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchHopeBook() async throws {
        let uid = "BC3B938E-E978-46E1-B2B4-E41C5EB0FAC2"
        let expected = [
            Item(
                id: "bw_zADCBuw0C",
                volumeInfo: VolumeInfo(
                    title: "Sad",
                    authors: ["Isabel Thomas"],
                    publisher: "Raintree",
                    publishedDate: "2014-05-08",
                    description: "This book, part of the Dealing with Feeling series, looks at sadness. Topics covered within the book include what it feels like to be sad, how to stop being sad, and how to help other people who might be feeling sad.",
                    industryIdentifiers: [],
                    pageCount: 26,
                    categories: ["Sadness"],
                    imageLinks: ImageLinks(smallThumbnail: "http://books.google.com/books/content?id=bw_zADCBuw0C&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api")
                )
            )
        ]
                        
        let result = try await FirestoreManager.fetchHopeBook(uid: uid)
        
        XCTAssertEqual(result, expected, "HopeBooks")
        
    }
}
