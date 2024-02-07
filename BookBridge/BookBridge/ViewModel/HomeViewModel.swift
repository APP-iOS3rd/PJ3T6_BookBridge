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
    @Published var changeNoticeBoards: [NoticeBoard] = []
    @Published var findNoticeBoards: [NoticeBoard] = []
    
    //@Published var noticeBoards: [NoticeBoard] = []
    
    let db = Firestore.firestore()
    let nestedGroup = DispatchGroup()
}
extension HomeViewModel {
    func gettingChangeNoticeBoards() {
        db.collection("noticeBoard").whereField("isChange", isEqualTo: true).getDocuments { querySnapshot, err in
            guard err == nil else { return }
            guard let documents = querySnapshot?.documents else { return }
            
            for document in documents {
                var thumnailImage = ""

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
                print(noticeBoard)
                
                DispatchQueue.main.async {
                    self.changeNoticeBoards.append(noticeBoard)
                }
            }
        }
    }
    
    func gettingFindNoticeBoards() {
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
                        print(noticeBoard)
                        
                        DispatchQueue.main.async {
                            self.findNoticeBoards.append(noticeBoard)
                        }
                    }
                }
            }
        }
    }
    /*
    func gettingAllDocs() {
        db.collection("noticeBoard").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let documents = querySnapshot?.documents else { return }
                
                for document in documents {
                    
                    self.db.collection("noticeBoard").document(document.documentID).collection("hopeBooks").getDocuments { (QuerySnapshot, Error) in
                        guard let hopeDocuments = QuerySnapshot?.documents else {
                            return
                        }
                        
                        var hopeBooks: [Item] = []
                        var thumnailImage = ""
                        
                        let nestedGroup = DispatchGroup() // Nested DispatchGroup
                        
                        if document.data()["date"] is Timestamp {
                            guard let stamp = document.data()["date"] as? Timestamp else {
                                return
                            }
                            for doc in hopeDocuments {
                                if doc.exists {
                                    nestedGroup.enter() // Enter nested DispatchGroup
                                    
                                    if (doc.data()["imageLinks"] as? String ?? "") != "" {
                                        thumnailImage = (doc.data()["imageLinks"] as? String ?? "")
                                    } else {
                                        thumnailImage = ""
                                    }
                                    
                                    self.db.collection("noticeBoard").document(document.documentID).collection("hopeBooks").document(doc.documentID).collection("industryIdentifiers").getDocuments { (querySnapshot, error) in
                                        guard let industryIdentifiers = querySnapshot?.documents else {
                                            nestedGroup.leave() // Leave nested DispatchGroup
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
                                        
                                        nestedGroup.leave() // Leave nested DispatchGroup
                                    }
                                } else {
                                    thumnailImage = ""
                                    nestedGroup.leave() // Leave nested DispatchGroup
                                }
                                
                            }
                            
                            nestedGroup.notify(queue: .main) {
                                // All tasks in nested DispatchGroup completed
                                let noticeBoard = NoticeBoard(
                                    id: document.data()["noticeBoardId"] as! String,
                                    userId: document.data()["userId"] as! String,
                                    noticeBoardTitle: document.data()["noticeBoardTitle"] as! String,
                                    noticeBoardDetail: document.data()["noticeBoardDetail"] as! String,
                                    noticeImageLink: document.data()["noticeImageLink"] as! [String],
                                    noticeLocation: document.data()["noticeLocation"] as! [Double],
                                    isChange: document.data()["isChange"] as! Bool,
                                    state: document.data()["state"] as! Int,
                                    date: stamp.dateValue(),
                                    hopeBook: hopeBooks
                                )
                                print(noticeBoard)
                                
                                DispatchQueue.main.async {
                                    self.noticeBoards.append(noticeBoard)
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }*/
}
//
//extension HomeViewModel {
//    func gettingAllDocs() {
//        db.collection("noticeBoard").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                guard let documents = querySnapshot?.documents else { return }
//                
//                for document in documents {
//                    self.db.collection("noticeBoard").document(document.documentID).collection("hopeBooks").getDocuments { (QuerySnapshot, Error) in
//                        
//                        guard let hopeDocuments = QuerySnapshot?.documents else { return }
//                        
//                        var hopeBooks: [Item] = []
//                        var thumnailImage = ""
//                        
//                        if document.data()["date"] is Timestamp {
//                            guard let stamp = document.data()["date"] as? Timestamp else {
//                                return
//                            }
//                            
//                            if (document.data()["isChange"] as? Bool ?? false ) {
//                                if (document.data()["noticeImageLink"] as? [String] ?? []).isEmpty {
//                                    thumnailImage = ""
//                                } else {
//                                    //TODO: 대표 이미지로 바껴야됨
//                                    thumnailImage = (document.data()["noticeImageLink"] as! [String])[0]
//                                }
//                            } else {
//                                DispatchQueue.global().sync {
//                                    for doc in hopeDocuments {
//                                        if doc.exists {
//                                            if (doc.data()["imageLinks"] as? String ?? "") != "" {
//                                                thumnailImage = (doc.data()["imageLinks"] as? String ?? "")
//                                            } else {
//                                                thumnailImage = ""
//                                            }
//                                            
//                                            self.db.collection("noticeBoard").document(document.documentID).collection("hopeBooks").document(doc.documentID).collection("industryIdentifiers").getDocuments { (querySnapshot, error) in
//                                                guard let industryIdentifiers = querySnapshot?.documents else { return }
//                                                
//                                                var isbn: [IndustryIdentifier] = []
//                                                for industryIdentifier in industryIdentifiers {
//                                                    isbn.append(IndustryIdentifier(identifier: industryIdentifier.documentID))
//                                                }
//                                                
//                                                let item = Item(id: doc.documentID, volumeInfo: VolumeInfo(
//                                                    title: doc.data()["title"] as? String ?? "",
//                                                    authors: (doc.data()["authors"] as? [String] ?? [""]),
//                                                    publisher: doc.data()["publisher"] as? String ?? "",
//                                                    publishedDate: doc.data()["publishedDate"] as? String ?? "",
//                                                    description: doc.data()["description"] as? String ?? "",
//                                                    industryIdentifiers: isbn,
//                                                    pageCount: doc.data()["pageCount"] as? Int ?? 0,
//                                                    categories: doc.data()["categories"] as? [String] ?? [""],
//                                                    imageLinks: ImageLinks(smallThumbnail: doc.data()["imageLinks"] as? String ?? "")))
//                                                
//                                                hopeBooks.append(item)
//                                                print("kt")
//                                            }
//                                        } else {
//                                            thumnailImage = ""
//                                        }
//                                    }
//                                    print("abc")
//                                }
//                                print("sdf")
//                            }
//                            
//                            let noticeBoard = NoticeBoard(
//                                id: document.data()["noticeBoardId"] as! String,
//                                userId: document.data()["userId"] as! String,
//                                noticeBoardTitle: document.data()["noticeBoardTitle"] as! String,
//                                noticeBoardDetail: document.data()["noticeBoardDetail"] as! String,
//                                noticeImageLink: document.data()["noticeImageLink"] as! [String],
//                                noticeLocation: document.data()["noticeLocation"] as! [Double],
//                                isChange: document.data()["isChange"] as! Bool,
//                                state: document.data()["state"] as! Int,
//                                date: stamp.dateValue(),
//                                hopeBook: hopeBooks
//                            )
//                            
//                            DispatchQueue.main.async {
//                                self.noticeBoards.append(noticeBoard)
//                            }
//                        }
//                    }
//                }
//                
//            }
//        }
//    }
//    
//}
//
//extension HomeViewModel {
//
//}
