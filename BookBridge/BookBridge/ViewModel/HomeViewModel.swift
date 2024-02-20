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
    @Published var changeNoticeBoardsDic: [String: UIImage] = [:]
    @Published var findNoticeBoards: [NoticeBoard] = []
    @Published var findNoticeBoardsDic: [String: UIImage] = [:]
    @Published var recentSearch : [String] = []
            
    let db = Firestore.firestore()
    let nestedGroup = DispatchGroup()
    let userManager = UserManager.shared
    let locationManager = LocationManager.shared
}

// MARK: - 게시물
extension HomeViewModel {
    
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
                let changeBoards = await GeohashManager.geoQuery(
                    lat: lat,
                    long: long,
                    distance: distance,
                    type: .change
                )
                
                let findBoards = await GeohashManager.geoQuery(
                    lat: lat,
                    long: long,
                    distance: distance,
                    type: .find
                )
                                
                DispatchQueue.main.async {
                    self.changeNoticeBoards = changeBoards
                    self.findNoticeBoards = findBoards
                }
            }
        }
    }
    
}

// MARK: - 이미지
extension HomeViewModel {
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
