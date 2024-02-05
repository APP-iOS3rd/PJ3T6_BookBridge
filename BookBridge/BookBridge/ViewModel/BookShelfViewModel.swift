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
    @Published var wishBooks: [Item] = []
    @Published var holdBooks: [Item] = []
    @Published var filteredBooks: [Item] = []

    func filterBooks(for tap: tapInfo, searchText: String) {
        let books = (tap == .wish ? wishBooks : holdBooks)
        if searchText.isEmpty {
            
            filteredBooks = books
        } else {
            filteredBooks = books.filter { $0.volumeInfo.title?.contains(searchText) ?? false }
        }
    }
    
    
    func fetchBooks(for tap : tapInfo) {
        if tap == .wish {
            filteredBooks = (wishBooks)
        }
        else {
            filteredBooks = (holdBooks)
        }
        
    }
    




    
}

