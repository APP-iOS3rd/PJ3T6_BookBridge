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

    func testFetchHopBook() throws {
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
            ),
//            Item(
//                id: "e7g_EAAAQBAJ",
//                volumeInfo: VolumeInfo(
//                    title: "Life is Sad and Beautiful",
//                    authors: ["Hussain Manawer"],
//                    publisher: "Raintree",
//                    publishedDate: "2014-05-08",
//                    description: "This book, part of the Dealing with Feeling series, looks at sadness. Topics covered within the book include what it feels like to be sad, how to stop being sad, and how to help other people who might be feeling sad.",
//                    industryIdentifiers: [],
//                    pageCount: 26,
//                    categories: ["Sadness"],
//                    imageLinks: ImageLinks(smallThumbnail: <#T##String?#>)
//                )
//            )
        ]
        
        
        // XCTestExpectation을 생성합니다.
        let expectation = XCTestExpectation(description: "Fetch Hope Book")
        
        FirestoreManager.fetchHopeBook(uid: uid) { hopeBooks in
            // 테스트를 위해 가져온 결과를 출력합니다.
            print(hopeBooks)
            
            // 비동기 작업이 완료되었음을 XCTestExpectation에 알립니다.
            expectation.fulfill()
        }
        
        // XCTestExpectation이 충족될 때까지 대기합니다.
        wait(for: [expectation], timeout: 10.0) // 10초간 대기하도록 설정하였습니다. 시간은 필요에 따라 조절할 수 있습니다.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
