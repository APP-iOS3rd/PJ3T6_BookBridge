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
    
    var userId : String?
    
    init(userId: String?) {
        self.userId = userId
    }
    
    func filterBooks(for tap: tapInfo, searchText: String) {
        let books = (tap == .wish ? wishBooks : holdBooks)
        if searchText.isEmpty {
            
            filteredBooks = books
        } else {
            filteredBooks = books.filter { $0.volumeInfo.title?.contains(searchText) ?? false }
        }
    }
    
    
    func fetchBooks(for tap: tapInfo) {
        
        if tap == .wish {
            loadBooksFromFirestore(collection: "wishBooks") { [weak self] in
                self?.filteredBooks = self?.wishBooks ?? []
            }
        } else {
            loadBooksFromFirestore(collection: "holdBooks") { [weak self] in
                self?.filteredBooks = self?.holdBooks ?? []
            }
        }
    }
    
    
    func saveBooksToFirestore(books: [Item], collection: String) {
        guard let userId = userId else { return }
        let db = Firestore.firestore()
        
        books.forEach { book in
            let document = db.collection("User").document("\(userId)").collection(collection).document(book.id)
            let bookInfo = book.volumeInfo
            
            var industryIdentifierData: String? = nil
            if let firstIdentifier = bookInfo.industryIdentifiers?.first?.identifier {
                industryIdentifierData = firstIdentifier
            }
            
            var dataToSet: [String: Any] = [
                "title": bookInfo.title ?? "제목 미상",
                "authors": bookInfo.authors ?? ["저자 미상"],
                "publisher": bookInfo.publisher ?? "출판사 미상",
                "publishedDate": bookInfo.publishedDate ?? "출판 날짜 미상",
                "description": bookInfo.description ?? "설명이 없어요..",
                "pageCount": bookInfo.pageCount ?? 0,
                "categories": bookInfo.categories ?? ["장르 미상"],
                "imageLinks": bookInfo.imageLinks?.smallThumbnail ?? ""
            ]
            
            if let industryIdentifier = industryIdentifierData {
                dataToSet["industryIdentifier"] = industryIdentifier
            }
            
            document.setData(dataToSet)
        }
    }
   


    
    func loadBooksFromFirestore(collection: String, completion: @escaping () -> Void) {
        guard let userId = userId else { return }
        let db = Firestore.firestore()
        
        db.collection("User").document(userId).collection(collection).getDocuments { [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents, error == nil else {
                print("Error getting documents: \(error?.localizedDescription ?? "")")
                return
            }
            
            var items: [Item] = []
            for document in documents {
                let data = document.data()
                let volumeInfo = VolumeInfo(
                    title: data["title"] as? String,
                    authors: data["authors"] as? [String],
                    publisher: data["publisher"] as? String,
                    publishedDate: data["publishedDate"] as? String,
                    description: data["description"] as? String,
                    industryIdentifiers: [IndustryIdentifier(identifier: data["industryIdentifier"] as? String)],
                    pageCount: data["pageCount"] as? Int,
                    categories: data["categories"] as? [String],
                    imageLinks: ImageLinks(smallThumbnail: data["imageLinks"] as? String)
                )
                let item = Item(id: document.documentID, volumeInfo: volumeInfo)
                items.append(item)
            }
            
            DispatchQueue.main.async {
                if collection == "wishBooks" {
                    self?.wishBooks = items
                    self?.filteredBooks = items
                } else if collection == "holdBooks" {
                    self?.holdBooks = items
                    self?.filteredBooks = items
                }
            }
            completion()
        }
    }
    
    func deleteBook(_ book: Item, for tap: tapInfo) {
        // 내부 배열에서 책 제거
        switch tap {
        case .wish:
            if let index = wishBooks.firstIndex(where: { $0.id == book.id }) {
                wishBooks.remove(at: index)
            }
        case .hold:
            if let index = holdBooks.firstIndex(where: { $0.id == book.id }) {
                holdBooks.remove(at: index)
            }
        }

        // Firestore에서도 책 제거
        guard let userId = userId else { return }
        let db = Firestore.firestore()
        let collectionName = (tap == .wish) ? "wishBooks" : "holdBooks"

        db.collection("User").document(userId).collection(collectionName).document(book.id).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            }
        }
    }

}


