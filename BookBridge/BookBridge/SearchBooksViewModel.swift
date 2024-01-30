//
//  SearchBooksViewModel.swift
//  BookBridge
//
//  Created by 노주영 on 1/30/24.
//

import Foundation

class SearchBooksViewModel: ObservableObject {
    @Published var searchBooks: Book = Book.init(items: [])
    @Published var selectBooks: Book = Book.init(items: [])
    @Published var text: String = ""
}

extension SearchBooksViewModel {
    //책 선택 메서드
    func doSelectBook(book: Item) {
        selectBooks.items.append(book)
    }
    
    //책 삭제 메서드
    func deleteSelectBook(book: Item) {
        if let index = selectBooks.items.firstIndex(where: { $0.id == book.id }) {
            selectBooks.items.remove(at: index)
        }
    }
}
