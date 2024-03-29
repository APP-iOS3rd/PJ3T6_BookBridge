//
//  StringExtension_Tests.swift
//  BookBridgeTests
//
//  Created by 이민호 on 2/22/24.
//

import XCTest
@testable import BookBridge

final class StringExtension_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let randomNickname = CreationManager.getRandomNickname()
        print("닉네임: \(randomNickname)")
    }
}
