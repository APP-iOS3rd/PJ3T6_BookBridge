//
//  BookModel.swift
//  BookBridge
//
//  Created by 노주영 on 1/30/24.
//

import Foundation

struct Book: Codable {
    var totalItems: Int
    var items: [Item]
}

struct Item: Codable, Identifiable, Equatable {
    let id: String
    let volumeInfo: VolumeInfo
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id && lhs.volumeInfo == rhs.volumeInfo
    }
}

struct VolumeInfo: Codable, Equatable {
    let title: String?                                        //제목
    let authors: [String]?                                    //저자
    let publisher: String?                                   //출판사
    let publishedDate: String?                                //출판일
    let description: String?
    let industryIdentifiers: [IndustryIdentifier]?            //ISBN
    let pageCount: Int?                                       //쪽수
    let categories: [String]?                                //장르
    let imageLinks: ImageLinks?                              //이미지 링크
    
    static func == (lhs: VolumeInfo, rhs: VolumeInfo) -> Bool {
        return lhs.title == rhs.title &&
            lhs.authors == rhs.authors &&
            lhs.publisher == rhs.publisher &&
            lhs.publishedDate == rhs.publishedDate &&
            lhs.description == rhs.description &&
            lhs.industryIdentifiers == rhs.industryIdentifiers &&
            lhs.pageCount == rhs.pageCount &&
            lhs.categories == rhs.categories &&
            lhs.imageLinks == rhs.imageLinks
    }
}

struct IndustryIdentifier: Codable, Equatable {
    var identifier: String?
}

struct ImageLinks: Codable, Equatable {
    var smallThumbnail: String?
}







