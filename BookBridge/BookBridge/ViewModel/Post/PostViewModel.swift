//
//  PostViewModel.swift
//  BookBridge
//
//  Created by jonghyun baik on 2/7/24.
//

import Foundation
import FirebaseFirestore

class PostViewModel: ObservableObject {
    @Published var user: UserModel = UserModel()
    @Published var wishBooks: [Item] = []
    @Published var holdBooks: [Item] = []
        
    let db = Firestore.firestore()
}

extension PostViewModel {
    func gettingUserInfo(userId : String) {
        let docRef = db.collection("User").document(userId)
        print(userId)
        
        docRef.getDocument { document, error in
            guard error == nil else {
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    print("data", data)
                    
                    let user = UserModel(
                        id: data["id"] as? String,
                        email: data["email"] as? String,
                        nickname: data["nickname"] as? String,
                        profileURL: data["profileURL"] as? String,
                        dong: data["dong"] as? [String]
                    )
                    
                    DispatchQueue.main.async {
                        self.user = user
                    }
                }
            }
        }
    }
    
    func gettingUserBookShelf(userId: String, collection: String) {
        
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
                } else if collection == "holdBooks" {
                    self?.holdBooks = items
                }
            }
        }
    }
}
