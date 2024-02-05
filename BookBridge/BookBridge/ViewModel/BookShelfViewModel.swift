//
//  BookShelfViewModel.swift
//  BookBridge
//
//  Created by 김건호 on 2/1/24.
//

import Foundation
import Firebase
import FirebaseFirestore

class BookShelfViewModel: ObservableObject {
    @Published var wishBooks: [Book] = []
    @Published var holdBooks: [Book] = []
    @Published var filteredBooks: [Item] = []

    func filterBooks(for tap: tapInfo, searchText: String) {
        let books = (tap == .wish ? wishBooks : holdBooks).flatMap { $0.items }
        if searchText.isEmpty {
            filteredBooks = books
        } else {
            filteredBooks = books.filter { $0.volumeInfo.title?.contains(searchText) ?? false }
        }
    }
    
    
    func fetchBooks(for tap : tapInfo) {
        if tap == .wish {
            filteredBooks = (wishBooks).flatMap { $0.items }
        }
        else {
            filteredBooks = (holdBooks).flatMap { $0.items }
        }
        
    }
    
    //하드 코딩용 자료입니다.
    init() {
        loadSampleData()
    }
    
    func loadSampleData() {
        // Wish Books 예시 데이터
        wishBooks = (1...10).map { i in
            Book(totalItems: 1, items: [Item(id: String(i), volumeInfo: VolumeInfo(title: "Wish Book \(i)", authors: ["Author \(i)"], publisher: "Publisher \(i)", publishedDate: "202\(i - 1)", description: "Description \(i)", industryIdentifiers: [IndustryIdentifier(identifier: "ISBN\(i)")], pageCount: 100 + i * 10, categories: ["Fiction"], imageLinks: ImageLinks(smallThumbnail: "https://example.com/image\(i).jpg")))])
        }

        // Hold Books 예시 데이터
        holdBooks = (11...20).map { i in
            Book(totalItems: 1, items: [Item(id: String(i), volumeInfo: VolumeInfo(title: "Hold Book \(i)", authors: ["Author \(i)"], publisher: "Publisher \(i)", publishedDate: "202\(i - 11)", description: "Description \(i)", industryIdentifiers: [IndustryIdentifier(identifier: "ISBN\(i)")], pageCount: 200 + i * 10, categories: ["Non-Fiction"], imageLinks: ImageLinks(smallThumbnail: "https://example.com/image\(i).jpg")))])
        }
    }



    
}

