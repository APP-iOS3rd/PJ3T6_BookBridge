//
//  MyPageViewModel.swift
//  BookBridge
//
//  Created by 노주영 on 2/13/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class MyPageViewModel: ObservableObject {
    @Published var userRequests: [String] = []
    @Published var userBookMarks: [String] = []
    @Published var myNoticeBoardCount: Int = 0
    
    let db = Firestore.firestore()
}

extension MyPageViewModel {
    func getUserInfo() {
        let query = db.collection("user").document("joo")
        
        query.getDocument { documentSnapshot, error in
            guard error == nil else { return }
            guard let document = documentSnapshot else { return }
            
            self.userRequests = document.data()?["requests"] as? [String] ?? []
            self.userBookMarks = document.data()?["bookMark"] as? [String] ?? []
        }
        
        query.collection("myNoticeBoard").getDocuments { querySnapshot, error in
            guard error == nil else { return }
            guard let documents = querySnapshot else { return }
            
            self.myNoticeBoardCount = documents.count
        }
    }
}
