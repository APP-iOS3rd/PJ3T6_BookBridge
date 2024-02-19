//
//  HomeViewModel.swift
//  BookBridge
//
//  Created by jonghyun baik on 2/1/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class HomeViewModel: ObservableObject {
    @Published var bookMarks: [String] = []
    @Published var changeNoticeBoards: [NoticeBoard] = []
    @Published var findNoticeBoards: [NoticeBoard] = []
    @Published var recentSearch : [String] = []
    
    let db = Firestore.firestore()
    let nestedGroup = DispatchGroup()
    let userManager = UserManager.shared
    let locationManager = LocationManager.shared
}

extension HomeViewModel {
    func gettingChangeNoticeBoards() {
        self.changeNoticeBoards = []
        
        db.collection("noticeBoard").whereField("isChange", isEqualTo: true).getDocuments { querySnapshot, err in
            guard err == nil else { return }
            guard let documents = querySnapshot?.documents else { return }
            
            for document in documents {
                
                guard let stamp = document.data()["date"] as? Timestamp else { return }
                
                let noticeBoard = NoticeBoard(
                    id: document.data()["noticeBoardId"] as! String,
                    userId: document.data()["userId"] as! String,
                    noticeBoardTitle: document.data()["noticeBoardTitle"] as! String,
                    noticeBoardDetail: document.data()["noticeBoardDetail"] as! String,
                    noticeImageLink: document.data()["noticeImageLink"] as! [String],
                    noticeLocation: document.data()["noticeLocation"] as! [Double],
                    noticeLocationName: document.data()["noticeLocationName"] as! String,
                    isChange: document.data()["isChange"] as! Bool,
                    state: document.data()["state"] as! Int,
                    date: stamp.dateValue(),
                    hopeBook: []
                )
                
                DispatchQueue.main.async {
                    self.changeNoticeBoards.append(noticeBoard)
                }
            }
        }
    }
    
    func gettingFindNoticeBoards() {
        self.findNoticeBoards = []
        
        db.collection("noticeBoard").whereField("isChange", isEqualTo: false).getDocuments { querySnapshot, err in
            guard err == nil else { return }
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
                            id: document.data()["noticeBoardId"] as! String,
                            userId: document.data()["userId"] as! String,
                            noticeBoardTitle: document.data()["noticeBoardTitle"] as! String,
                            noticeBoardDetail: document.data()["noticeBoardDetail"] as! String,
                            noticeImageLink: document.data()["noticeImageLink"] as! [String],
                            noticeLocation: document.data()["noticeLocation"] as! [Double],
                            noticeLocationName: document.data()["noticeLocationName"] as! String,
                            isChange: document.data()["isChange"] as! Bool,
                            state: document.data()["state"] as! Int,
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
    
    func bookMarkToggle(user: String, id: String) {
        var bookMarks: [String] = []
        
        db.collection("user").document(user).getDocument { documentSnapshot, error in
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
            
            self.db.collection("user").document(user).updateData([
                "bookMark": bookMarks
            ])
            
            self.bookMarks = bookMarks
        }
    }
    
    func fetchBookMark(user: String) {
        var bookMarks: [String] = []
        
        db.collection("user").document(user).getDocument { documentSnapshot, error in
            guard error == nil else { return }
            guard let document = documentSnapshot else { return }
            
            bookMarks = document["bookMark"] as? [String] ?? []
            
            self.bookMarks = bookMarks
        }
    }
    
    
    func fetchRecentSearch(user: String) {
        db.collection("user").document(user).collection("recentsearch").getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error getting recent searches: \(error)")
                return
            }
            
            var searches: [String] = []
            for document in querySnapshot!.documents {
                if let search = document.data()["searchTerm"] as? String {
                    searches.append(search)
                }
            }
            DispatchQueue.main.async {
                self.recentSearch = searches
            }
        }
    }
    
    func recentSearchDeleteAll(user: String) {
        recentSearch.removeAll()
        
        // Firestore에서 해당 사용자의 모든 최근 검색 데이터 삭제
        let collectionRef = db.collection("user").document(user).collection("recentsearch")
        collectionRef.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("No documents in 'recentsearch'")
                return
            }
            
            for document in documents {
                collectionRef.document(document.documentID).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
            }
        }
    }
    
    
    func deleteRecentSearch(user: String, search: String) {
        if let index = recentSearch.firstIndex(of: search) {
            recentSearch.remove(at: index)
            
            // Firestore에서 해당 검색어 삭제
            db.collection("User").document(user).collection("recentsearch").whereField("searchTerm", isEqualTo: search).getDocuments { (snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print("No documents found")
                    return
                }
                
                for document in documents {
                    document.reference.delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                }
            }
        }
    }
    
    func addRecentSearch(user: String, text: String) {
        // Firestore에 검색어를 추가하는 로직
        let recentSearchRef = db.collection("User").document(user).collection("recentsearch")
        
        // 중복 검색어 방지
        recentSearchRef.whereField("searchTerm", isEqualTo: text).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else if querySnapshot!.documents.isEmpty {
                // 문서가 없으면 새로운 검색어 추가
                recentSearchRef.addDocument(data: ["searchTerm": text]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(recentSearchRef.document().documentID)")
                        DispatchQueue.main.async {
                            if !self.recentSearch.contains(text) {
                                self.recentSearch.append(text)
                            }
                        }
                    }
                }
            } else {
                // 이미 존재하는 검색어는 배열에 추가하지 않음
                print("Search term already exists.")
            }
        }
        
        self.fetchRecentSearch(user: user)
    }
    
    func updateNoticeBoards() {
        Task {
            var lat: Double?
            var long: Double?
            var distance: Int?
            
            if userManager.isLogin {
                if let selectedLocation = userManager.user?.getSelectedLocation() {
                    lat = selectedLocation.lat ?? 0.0
                    long = selectedLocation.long ?? 0.0
                    distance = selectedLocation.distance ?? 1
                }
            } else {
                lat = LocationManager.shared.lat
                long = LocationManager.shared.long
                distance = 1
            }
            
            if let lat = lat, let long = long, let distance = distance {
                let boards = await GeohashManager.geoQuery(
                    lat: lat,
                    long: long,
                    distance: distance
                )
                
                DispatchQueue.main.async {
                    self.changeNoticeBoards = boards
                }
            }
        }
        
    }
}
