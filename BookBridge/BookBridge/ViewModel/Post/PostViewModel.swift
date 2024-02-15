//
//  PostViewModel.swift
//  BookBridge
//
//  Created by jonghyun baik on 2/7/24.
//

import Foundation
import FirebaseFirestore

class PostViewModel: ObservableObject {
    @Published var bookMarks: [String] = []
    @Published var user: UserModel = UserModel()
    @Published var wishBooks: [Item] = []
    @Published var holdBooks: [Item] = []
        
    let db = Firestore.firestore()
}

extension PostViewModel {
    // MARK: 게시자 정보 fetch
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
                        joinDate: data["joinDate"] as? Date,
                        location: data["location"] as? [Location]
                    )
                    
                    DispatchQueue.main.async {
                        self.user = user
                    }
                }
            }
        }
    }
    
    // MARK: 게시자 책장 정보 fetch
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
    
    // MARK: 사용자 북마크 설정
    func bookMarkToggle(id: String) {
        var bookMarks: [String] = []
        
        db.collection("User").document(UserManager.shared.uid).getDocument { documentSnapshot, error in
            guard error == nil else { return }
            guard let document = documentSnapshot else { return }
            
            bookMarks = document["bookMark"] as? [String] ?? []
            
            if (bookMarks.contains { $0 == id }) {
                if let index = bookMarks.firstIndex(of: id) {
                    bookMarks.remove(at: index)
                }
            } else {
                bookMarks.append(id)
            }
            
            self.db.collection("User").document(UserManager.shared.uid).updateData([
                "bookMark": bookMarks
            ])
            
            self.bookMarks = bookMarks
        }
    }
    
    // MARK: 사용자 북마크 정보 fetch
    func fetchBookMark() {
        var bookMarks: [String] = []
        
        db.collection("User").document(UserManager.shared.uid).getDocument { documentSnapshot, error in
            guard error == nil else { return }
            guard let document = documentSnapshot else { return }
            
            bookMarks = document["bookMark"] as? [String] ?? []
            
            self.bookMarks = bookMarks
        }
    }
}


// TODO: 채팅하기 벼튼 및 네비게이션을 위한 data fetch
/*
 내 게시글
    - ChatRoomListView 로 감  w. (noticeBoardId)
    - User/userid/chatRoomList/ 에 where noticeBoardid 가 일치하는 갯수 가져옴
 다른 사람 게시글
    - 진행중인 채팅방이 있을 경우
        - User/userid/chatRoomList/ 에 where noticeBoardid 가 일치하는 채팅 모델을 가져옴
        - status 판단 후 status에 따른 뷰 설정
        - (chatRoomId, userId, noticeBoardId, 게시글 작성자 id)
    - 진행중인 채팅방이 없을 경우
        - User/userid/chatRoomList/ 에 where noticeBoardid 가 일치하는 채팅 모델 검색 후 없으면
        - 채팅하기 로 뷰 설정
        - (chatRoomId = "", userId, noticeBoardId, 게시글 작성자 id)
 */

extension PostViewModel {
    
}
