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

struct Item: Codable, Identifiable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String?                                        //제목
    let authors: [String]?                                    //저자
    let publisher: String?                                   //출판사
    let publishedDate: String?                                //출판일
    let description: String?
    let industryIdentifiers: [IndustryIdentifier]?            //ISBN
    let pageCount: Int?                                       //쪽수
    let categories: [String]?                                //장르
    let imageLinks: ImageLinks?                              //이미지 링크
}

struct IndustryIdentifier: Codable {
    var identifier: String?
}

struct ImageLinks: Codable {
    var smallThumbnail: String?
}







