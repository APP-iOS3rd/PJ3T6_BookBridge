//
//  PostViewModel.swift
//  BookBridge
//
//  Created by jonghyun baik on 2/7/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class PostViewModel: ObservableObject {
    @Published var bookMarks: [String] = []
    @Published var chatRoomList: [String] = []
    @Published var holdBooks: [Item] = []
    @Published var wishBooks: [Item] = []
    @Published var user: UserModel = UserModel()
    @Published var userChatRoomId: String = ""
    @Published var userUIImage: UIImage = UIImage(named: "Character")!
        
    let db = Firestore.firestore()
}

// MARK: 게시자 정보
extension PostViewModel {
    func gettingUserInfo(userId : String) {
        let docRef = db.collection("User").document(userId)
        
        docRef.getDocument { document, error in
            guard error == nil else {
                return
            }
            
            if let document = document, document.exists {
                if let data = document.data(){
                    guard let locationData = data["location"] as? [Any] else { return }
                    print("!23")
                    do {
                        // location 데이터를 다시 JSON 데이터로 변환합니다.
                        let locationJsonData = try JSONSerialization.data(withJSONObject: locationData, options: [])
                        
                        // JSON 데이터를 사용하여 [Location]을 디코딩합니다.
                        let userLocations = try JSONDecoder().decode([Location].self, from: locationJsonData)
                        
                        let user = UserModel(
                            id: data["id"] as? String ?? "",
                            nickname: data["nickname"] as? String ?? "",
                            profileURL: data["profileURL"] as? String ?? "",
                            fcmToken: data["fcmToken"] as? String ?? "",
                            location: userLocations,
                            style: data["style"] as? String ?? "",
                            reviews: data["reviews"] as? [Int] ?? [0, 0, 0]
                        )
                        
                        self.getPartnerImage(urlString: data["profileURL"] as? String ?? "")
                        
                        DispatchQueue.main.async {
                            self.user = user
                        }
                    } catch {
                        print("Error decoding User locations: \(error)")

                    }
                }
            }
        }
    }
    
    //게시자 메너점수
    func getMannerScore() -> Int {
        guard let reviews = user.reviews else { return -1 }
        
        guard reviews.count == 3 else { return -1 }
        
        if reviews[0] == 0 && reviews[1] == 0 && reviews[2] == 0{
            return -1
        } else {
            return Int((Double(reviews[0] * 3)) / Double(((reviews[0] * 3) + (reviews[1] * 2) + (reviews[2] * 1))) * 100)
        }
    }
}

// MARK: 게시자 책장 정보
extension PostViewModel {
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

// MARK: 설정 부분 (...)
extension PostViewModel {
    //사용자 북마크 정보 fetch
    func fetchBookMark() {
        var bookMarks: [String] = []
        
        db.collection("User").document(UserManager.shared.uid).getDocument { documentSnapshot, error in
            guard error == nil else { return }
            guard let document = documentSnapshot else { return }
            
            bookMarks = document["bookMarks"] as? [String] ?? []
            
            self.bookMarks = bookMarks
        }
    }
    
    //사용자 북마크 설정
    func bookMarkToggle(id: String) {
        var bookMarks: [String] = []
        
        db.collection("User").document(UserManager.shared.uid).getDocument { documentSnapshot, error in
            guard error == nil else { return }
            guard let document = documentSnapshot else { return }
            
            bookMarks = document["bookMarks"] as? [String] ?? []
            
            if (bookMarks.contains { $0 == id }) {
                if let index = bookMarks.firstIndex(of: id) {
                    bookMarks.remove(at: index)
                }
            } else {
                bookMarks.append(id)
            }
            
            self.db.collection("User").document(UserManager.shared.uid).updateData([
                "bookMarks": bookMarks
            ])
            
            self.bookMarks = bookMarks
        }
    }
    
    // Firestore에서 게시물 삭제
    func deletePost(noticeBoardId: String) {
        db.collection("noticeBoard").document(noticeBoardId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                // 사용자 게시물 목록에서 게시물 삭제
                self.deleteFromUserPosts(noticeBoardId: noticeBoardId)
                // Storage에서 해당 게시물의 이미지 폴더 삭제
                self.deleteFolder(folderPath: "NoticeBoard/\(noticeBoardId)")
            }
        }
    }

    // 사용자 게시물 목록에서 삭제
    private func deleteFromUserPosts(noticeBoardId: String) {
        db.collection("User").document(UserManager.shared.uid).collection("myNoticeBoard").document(noticeBoardId).delete() { err in
            if let err = err {
                print("Error removing document from user posts: \(err)")
            } else {
                print("Document successfully removed from user posts!")
            }
        }
    }

    // 폴더 삭제 함수
    func deleteFolder(folderPath: String) {
        let storageRef = Storage.storage().reference().child(folderPath)
        
        // 폴더 내의 모든 파일(이미지) 삭제
        storageRef.listAll { (result, error) in
            // result가 nil이 아닐 때만 진행
            guard let result = result else {
                print("Error: result is nil")
                return
            }
            
            if let error = error {
                // 에러 처리
                print("Error listing files: \(error)")
                return
            }

            // 각 파일을 순회하며 삭제
            for item in result.items {
                item.delete { error in
                    if let error = error {
                        // 에러 처리
                        print("Error deleting file: \(error)")
                    } else {
                        // 성공적으로 삭제됨
                        print("File successfully deleted: \(item.name)")
                    }
                }
            }
        }
    }
}

// MARK: 대화중인 방 가져오기
extension PostViewModel {
    func fetchChatList(noticeBoardId: String) {
        let docRef = db.collection("User").document(UserManager.shared.uid).collection("chatRoomList").whereField("noticeBoardId", isEqualTo: noticeBoardId)
            
        docRef.getDocuments { [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents, error == nil else {
                print("Error getting documents: \(error?.localizedDescription ?? "")")
                return
            }
            
            var items: [String] = []
            for document in documents {
                let data = document.data()
                
                let item = data["id"] as? String
                items.append(item ?? "")
            }
            
            DispatchQueue.main.async {
                self?.chatRoomList = items
            }
        }
    }
}

// MARK: 채팅
extension PostViewModel {
    //채팅방 ID 가져오기
    func getChatRoomId(noticeBoardId: String, completion: @escaping(Bool, String) -> ()) {
        db.collection("User").document(UserManager.shared.uid)
            .collection("chatRoomList").whereField("noticeBoardId", isEqualTo: noticeBoardId).getDocuments { querySnapshot, error in
                guard error == nil else { return }
                guard let documents = querySnapshot else { return }
                
                if !documents.isEmpty {
                    for document in documents.documents {
                        print(document.documentID)
                        completion(true, document.documentID)
                    }
                } else {
                    completion(false, "")
                }
            }
    }
}

// MARK: 사용자 UIImage
extension PostViewModel {
    func getPartnerImage(urlString: String) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let imageData = data else { return }
                
                DispatchQueue.main.async {
                    self.userUIImage = UIImage(data: imageData) ?? UIImage(named: "Character")!
                }
            }.resume()
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
