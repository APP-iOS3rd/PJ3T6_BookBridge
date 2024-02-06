//
//  HomeViewModel.swift
//  BookBridge
//
//  Created by jonghyun baik on 2/1/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class HomeViewModel : ObservableObject {
    static let share = HomeViewModel()
    let db = Firestore.firestore()

    
    @Published var noticeBoards : [NoticeBoard] = []
    
    var thumnailImage : String = ""
    
}

extension HomeViewModel {
    func gettingAllDocs() {
        
        db.collection("noticeBoard").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                    guard let documents = querySnapshot?.documents else {return}
                    
                for document in documents {
                    
                    self.db.collection("noticeBoard").document(document.data()["noticeBoardId"] as! String).collection("hopeBooks").getDocuments { (QuerySnapshot, Error) in
                        
                        guard let hopeDocuments = QuerySnapshot?.documents else {return}
                        if document.data()["date"] is Timestamp {
                            guard let stamp = document.data()["date"] as? Timestamp else {
                                return
                            }
                            
                            if (document.data()["isChange"] as! Bool) {
                                
                                if (document.data()["noticeImageLink"] as! [String]).isEmpty {
                                    self.thumnailImage = ""
                                } else {
                                    self.thumnailImage = (document.data()["noticeImageLink"] as! [String])[0]
                                }
                                
                            } else {
                                print(document.data()["isChange"] as! Bool)
                                for doc in hopeDocuments {
                                    if doc.exists {
                                        if doc.data()["imageLinks"] as! String != "" {
                                            self.thumnailImage = (doc.data()["imageLinks"] as! String)
                                        } else {
                                            self.thumnailImage = ""
                                        }
                                    } else {
                                        self.thumnailImage = ""
                                    }
                                }
                                
                            }
                            
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
                            
                            
                            
                            print(self.thumnailImage)
                            DispatchQueue.main.async {
                                self.noticeBoards.append(noticeBoard)
                            }
                        }
                    }
                }
                
            }
        }
    }
    
}

extension HomeViewModel {
    
}
