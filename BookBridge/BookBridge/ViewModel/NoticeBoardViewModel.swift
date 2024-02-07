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
    @Published var changeNoticeBoards: [NoticeBoard] = []
    @Published var findNoticeBoards: [NoticeBoard] = []
    
    let db = Firestore.firestore()
    let nestedGroup = DispatchGroup()
}
extension NoticeBoardViewModel {
    func gettingChangeNoticeBoards() {
        db.collection("user").document("joo").collection("myNoticeBoard").whereField("isChange", isEqualTo: true).getDocuments { querySnapshot, err in
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
        db.collection("user").document("joo").collection("myNoticeBoard").whereField("isChange", isEqualTo: false).getDocuments { querySnapshot, err in
            guard err == nil else { return }
            guard let documents = querySnapshot?.documents else { return }
            
            for document in documents {
                self.db.collection("user").document("joo").collection("myNoticeBoard").document(document.documentID).collection("hopeBooks").getDocuments { querySnapshot2, err2 in
                    guard err2 == nil else { return }
                    guard let hopeDocuments = querySnapshot2?.documents else { return }
                    
                    var hopeBooks: [Item] = []
                    
                    guard let stamp = document.data()["date"] as? Timestamp else { return }
                    
                    for doc in hopeDocuments {
                        if doc.exists {
                            self.nestedGroup.enter() // Enter nested DispatchGroup
                            
                            self.db.collection("user").document("joo").collection("myNoticeBoard").document(document.documentID).collection("hopeBooks").document(doc.documentID).collection("industryIdentifiers").getDocuments { (querySnapshot, error) in
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
}
