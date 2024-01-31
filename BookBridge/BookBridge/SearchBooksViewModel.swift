//
//  SearchBooksViewModel.swift
//  BookBridge
//
//  Created by 노주영 on 1/30/24.
//

import Foundation

class SearchBooksViewModel: ObservableObject {
    @Published var searchBooks: Book = Book.init(totalItems: 0, items: [])
    @Published var selectBooks: Book = Book.init(totalItems: 0, items: [])
    
    @Published var firstToTalCount: Int = 0
    @Published var isFinish: Bool = true
    @Published var startIndex: Int = 0
    @Published var saveText: String = ""
    @Published var text: String = ""
    
    var bookApiManger = BookAPIManger()
}

extension SearchBooksViewModel {
    //도서 api 호출
    func callBookApi() {
        bookApiManger.getData(text: text, startIndex: startIndex) { book in
            DispatchQueue.main.async {
                if self.firstToTalCount == 0 {
                    self.firstToTalCount = book.totalItems
                    self.searchBooks.totalItems = book.totalItems
                }
                
                self.searchBooks.items.append(contentsOf: book.items)
                self.startIndex += 20
                
                if self.firstToTalCount <= self.startIndex || self.startIndex >= 100 {
                    self.isFinish = true
                } else if self.firstToTalCount > 20 {
                    self.isFinish = false
                }
            }
        }
    }
}

extension SearchBooksViewModel {
    //도서 선택 메서드
    func doSelectBook(book: Item) {
        selectBooks.items.append(book)
    }
    
    //도서 삭제 메서드
    func deleteSelectBook(book: Item) {
        if let index = selectBooks.items.firstIndex(where: { $0.id == book.id }) {
            selectBooks.items.remove(at: index)
        }
    }
}
