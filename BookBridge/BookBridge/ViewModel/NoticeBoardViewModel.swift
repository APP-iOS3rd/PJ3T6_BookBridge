//
//  NoticeBoardViewModel.swift
//  BookBridge
//
//  Created by 노주영 on 2/7/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class NoticeBoardViewModel: ObservableObject {
    @Published var bookMarks: [String] = []
    @Published var changeNoticeBoards: [NoticeBoard] = []
    @Published var changeNoticeBoardsDic: [String: UIImage] = [:]
    @Published var findNoticeBoards: [NoticeBoard] = []
    @Published var findNoticeBoardsDic: [String: UIImage] = [:]
    @Published var filterChangeNoticeBoards: [NoticeBoard] = []
    @Published var filterFindNoticeBoards: [NoticeBoard] = []
    
    let db = Firestore.firestore()
    let nestedGroup = DispatchGroup()
    let userManager = UserManager.shared
}

//MARK: 게시물의 상태에 따른 필터
extension NoticeBoardViewModel {
    func getfilterNoticeBoard(noticeBoard: [NoticeBoard], index: Int, isRequests: Bool) -> [NoticeBoard] {
        let changeIndex = index - 1
        
        if changeIndex == -1 {                  //전체
            return noticeBoard
        } else {
            if isRequests {                     //1 예약중, 2 교환완료
                return noticeBoard.filter { $0.state == changeIndex + 1 }
            } else {                            //0 진행중, 1 예약중, 2 교환완료
                return noticeBoard.filter { $0.state == changeIndex }
            }
        }
    }
}

//MARK: FireStore에서 게시물 정보 가져오기
extension NoticeBoardViewModel {
    //바꿔요
    func gettingChangeNoticeBoards(whereIndex: Int, noticeBoardArray: [String]) {
        changeNoticeBoards = []
        
        var query: Query
        
        if whereIndex == 0 {                    //내 게시물
            query = db.collection("User").document(userManager.uid).collection("myNoticeBoard").whereField("isChange", isEqualTo: true)
        } else {                                //요청 내역 및 관심목록
            if noticeBoardArray.isEmpty {
                query = db.collection("noticeBoard").whereField("noticeBoardId", in: [""]).whereField("isChange", isEqualTo: true)
            } else {
                query = db.collection("noticeBoard").whereField("noticeBoardId", in: noticeBoardArray).whereField("isChange", isEqualTo: true)
            }
        }
        
        query.getDocuments { querySnapshot, error in
            guard error == nil else { return }
            guard let documents = querySnapshot?.documents else { return }
            
            for document in documents {
                var thumnailImage = ""

                guard let stamp = document.data()["date"] as? Timestamp else { return }
                
                let noticeBoard = NoticeBoard(
                    id: document.data()["noticeBoardId"] as? String ?? "",
                    userId: document.data()["userId"] as? String ?? "",
                    noticeBoardTitle: document.data()["noticeBoardTitle"] as? String ?? "",
                    noticeBoardDetail: document.data()["noticeBoardDetail"] as? String ?? "",
                    noticeImageLink: document.data()["noticeImageLink"] as? [String] ?? [],
                    noticeLocation: document.data()["noticeLocation"] as? [Double] ?? [],
                    noticeLocationName: document.data()["noticeLocationName"] as? String ?? "",
                    isChange: document.data()["isChange"] as? Bool ?? false,
                    state: document.data()["state"] as? Int ?? 0,
                    date: stamp.dateValue(),
                    hopeBook: []
                )
                
                DispatchQueue.main.async {
                    self.changeNoticeBoards.append(noticeBoard)
                }
            }
        }
    }
    
    //구해요
    func gettingFindNoticeBoards(whereIndex: Int, noticeBoardArray: [String]) {
        findNoticeBoards = []
        
        var query: Query
        
        if whereIndex == 0 {                    //내 게시물
            query = db.collection("User").document(userManager.uid).collection("myNoticeBoard").whereField("isChange", isEqualTo: false)
            
            query.getDocuments { querySnapshot, error in
                guard error == nil else { return }
                guard let documents = querySnapshot?.documents else { return }
                for document in documents {
                    self.db.collection("User").document(self.userManager.uid).collection("myNoticeBoard").document(document.documentID).collection("hopeBooks").getDocuments { querySnapshot2, err2 in
                        guard err2 == nil else { return }
                        guard let hopeDocuments = querySnapshot2?.documents else { return }
                        
                        var hopeBooks: [Item] = []
                        
                        guard let stamp = document.data()["date"] as? Timestamp else { return }
                        
                        for doc in hopeDocuments {
                            if doc.exists {
                                self.nestedGroup.enter() // Enter nested DispatchGroup
                                
                                self.db.collection("User").document(self.userManager.uid).collection("myNoticeBoard").document(document.documentID).collection("hopeBooks").document(doc.documentID).collection("industryIdentifiers").getDocuments { (querySnapshot, error) in
                                    guard let industryIdentifiers = querySnapshot?.documents else {
                                        self.nestedGroup.leave()
                                        return
                                    }
                                    
                                    var isbn: [IndustryIdentifier] = []
                                    for industryIdentifier in industryIdentifiers {
                                        isbn.append(IndustryIdentifier(identifier: industryIdentifier.documentID))
                                    }
                                    
                                    let item = Item(id: doc.documentID, volumeInfo: VolumeInfo(
                                        title: doc.data()["title"] as? String ?? "",
                                        authors: (doc.data()["authors"] as? [String] ?? [""]),
                                        publisher: doc.data()["publisher"] as? String ?? "",
                                        publishedDate: doc.data()["publishedDate"] as? String ?? "",
                                        description: doc.data()["description"] as? String ?? "",
                                        industryIdentifiers: isbn,
                                        pageCount: doc.data()["pageCount"] as? Int ?? 0,
                                        categories: doc.data()["categories"] as? [String] ?? [""],
                                        imageLinks: ImageLinks(smallThumbnail: doc.data()["imageLinks"] as? String ?? "")))
                                    
                                    hopeBooks.append(item)
                                    
                                    self.nestedGroup.leave() // Leave nested DispatchGroup
                                }
                            } else {
                                self.nestedGroup.leave() // Leave nested DispatchGroup
                            }
                        }
                        self.nestedGroup.notify(queue: .main) {
                            // All tasks in nested DispatchGroup completed
                            let noticeBoard = NoticeBoard(
                                id: document.data()["noticeBoardId"] as? String ?? "",
                                userId: document.data()["userId"] as? String ?? "",
                                noticeBoardTitle: document.data()["noticeBoardTitle"] as? String ?? "",
                                noticeBoardDetail: document.data()["noticeBoardDetail"] as? String ?? "",
                                noticeImageLink: document.data()["noticeImageLink"] as? [String] ?? [],
                                noticeLocation: document.data()["noticeLocation"] as? [Double] ?? [],
                                noticeLocationName: document.data()["noticeLocationName"] as? String ?? "",
                                isChange: document.data()["isChange"] as? Bool ?? false,
                                state: document.data()["state"] as? Int ?? 0,
                                date: stamp.dateValue(),
                                hopeBook: hopeBooks
                            )
                            
                            DispatchQueue.main.async {
                                self.findNoticeBoards.append(noticeBoard)
                            }
                        }
                    }
                }
            }
        } else {                                //요청 내역 및 관심목록
            if noticeBoardArray.isEmpty {
                query = db.collection("noticeBoard").whereField("noticeBoardId", in: [""]).whereField("isChange", isEqualTo: false)
                
            } else {
                query = db.collection("noticeBoard").whereField("noticeBoardId", in: noticeBoardArray).whereField("isChange", isEqualTo: false)
            }
            
            query.getDocuments { querySnapshot, error in
                guard error == nil else { return }
                guard let documents = querySnapshot?.documents else { return }
                for document in documents {
                    self.db.collection("noticeBoard").document(document.documentID).collection("hopeBooks").getDocuments { querySnapshot2, err2 in
                        guard err2 == nil else { return }
                        guard let hopeDocuments = querySnapshot2?.documents else { return }
                        
                        var hopeBooks: [Item] = []
                        
                        guard let stamp = document.data()["date"] as? Timestamp else { return }
                        
                        for doc in hopeDocuments {
                            if doc.exists {
                                self.nestedGroup.enter() // Enter nested DispatchGroup
                                
                                self.db.collection("noticeBoard").document(document.documentID).collection("hopeBooks").document(doc.documentID).collection("industryIdentifiers").getDocuments { (querySnapshot, error) in
                                    guard let industryIdentifiers = querySnapshot?.documents else {
                                        self.nestedGroup.leave()
                                        return
                                    }
                                    
                                    var isbn: [IndustryIdentifier] = []
                                    for industryIdentifier in industryIdentifiers {
                                        isbn.append(IndustryIdentifier(identifier: industryIdentifier.documentID))
                                    }
                                    
                                    let item = Item(id: doc.documentID, volumeInfo: VolumeInfo(
                                        title: doc.data()["title"] as? String ?? "",
                                        authors: (doc.data()["authors"] as? [String] ?? [""]),
                                        publisher: doc.data()["publisher"] as? String ?? "",
                                        publishedDate: doc.data()["publishedDate"] as? String ?? "",
                                        description: doc.data()["description"] as? String ?? "",
                                        industryIdentifiers: isbn,
                                        pageCount: doc.data()["pageCount"] as? Int ?? 0,
                                        categories: doc.data()["categories"] as? [String] ?? [""],
                                        imageLinks: ImageLinks(smallThumbnail: doc.data()["imageLinks"] as? String ?? "")))
                                    
                                    hopeBooks.append(item)
                                    
                                    self.nestedGroup.leave() // Leave nested DispatchGroup
                                }
                            } else {
                                self.nestedGroup.leave() // Leave nested DispatchGroup
                            }
                        }
                        self.nestedGroup.notify(queue: .main) {
                            // All tasks in nested DispatchGroup completed
                            let noticeBoard = NoticeBoard(
                                id: document.data()["noticeBoardId"] as? String ?? "",
                                userId: document.data()["userId"] as? String ?? "",
                                noticeBoardTitle: document.data()["noticeBoardTitle"] as? String ?? "",
                                noticeBoardDetail: document.data()["noticeBoardDetail"] as? String ?? "",
                                noticeImageLink: document.data()["noticeImageLink"] as? [String] ?? [],
                                noticeLocation: document.data()["noticeLocation"] as? [Double] ?? [],
                                noticeLocationName: document.data()["noticeLocationName"] as? String ?? "",
                                isChange: document.data()["isChange"] as? Bool ?? false,
                                state: document.data()["state"] as? Int ?? 0,
                                date: stamp.dateValue(),
                                hopeBook: hopeBooks
                            )
                            
                            DispatchQueue.main.async {
                                self.findNoticeBoards.append(noticeBoard)
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - 이미지
extension NoticeBoardViewModel {
    func getDownLoadImage(isChange: Bool, noticeBoardId: String, urlString: String) {
        if isChange {
            if !self.changeNoticeBoardsDic.contains(where: { $0.key == noticeBoardId }){
                if let url = URL(string: urlString) {
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                        guard error == nil else { return }
                        guard let imageData = data else { return }

                        DispatchQueue.main.async {
                            self.changeNoticeBoardsDic.updateValue(UIImage(data: imageData) ?? UIImage(named: "Character")!, forKey: noticeBoardId)
                        }
                    }.resume()
                }
            }
        } else {
            if !self.findNoticeBoardsDic.contains(where: { $0.key == noticeBoardId }){
                if let url = URL(string: urlString) {
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                        guard error == nil else { return }
                        guard let imageData = data else { return }

                        DispatchQueue.main.async {
                            self.findNoticeBoardsDic.updateValue(UIImage(data: imageData) ?? UIImage(named: "Character")!, forKey: noticeBoardId)
                        }
                    }.resume()
                }
            }
        }
    }
}

//MARK: 북마크
extension NoticeBoardViewModel {
    func fetchBookMark() {
        var bookMarks: [String] = []
        
        db.collection("User").document(userManager.uid).getDocument { documentSnapshot, error in
            guard error == nil else { return }
            guard let document = documentSnapshot else { return }
            
            bookMarks = document["bookMarks"] as? [String] ?? []
            
            self.bookMarks = bookMarks
        }
    }
    
    //추가, 해제
    func bookMarkToggle(id: String) {
        var bookMarks: [String] = []
        
        db.collection("User").document(userManager.uid).getDocument { documentSnapshot, error in
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
            
            self.db.collection("User").document(self.userManager.uid).updateData([
                "bookMarks": bookMarks
            ])
            
            self.bookMarks = bookMarks
        }
    }
}
