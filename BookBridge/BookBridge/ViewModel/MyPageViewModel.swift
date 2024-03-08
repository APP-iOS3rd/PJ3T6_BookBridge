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
    @Published var myNoticeBoardCount: Int = 0
    @Published var otherNoticeBoards: [String] = []
    @Published var userBookMarks: [String] = []
    @Published var userRequests: [String] = []
    @Published var userSaveImage: (String, UIImage) = ("", UIImage(named: "Character")!)
    
    let db = Firestore.firestore()
    let userManager = UserManager.shared
}

extension MyPageViewModel {
    func getUserInfo(otherUser: UserModel?) {
        if otherUser == nil {
            let query = db.collection("User").document(userManager.uid)
            
            query.getDocument { documentSnapshot, error in
                guard error == nil else { return }
                guard let document = documentSnapshot else { return }
                
                self.userRequests = document.data()?["requests"] as? [String] ?? []
                self.userBookMarks = document.data()?["bookMarks"] as? [String] ?? []
            }
            
            query.collection("myNoticeBoard").getDocuments { querySnapshot, error in
                guard error == nil else { return }
                guard let documents = querySnapshot else { return }
                
                self.myNoticeBoardCount = documents.count
            }
        } else {
            db.collection("User").document(otherUser?.id ?? "").collection("myNoticeBoard").getDocuments { querySnapshot, error in
                guard error == nil else { return }
                guard let documents = querySnapshot?.documents else { return }
                
                for document in documents {
                    self.otherNoticeBoards.append(document.documentID)
                }
            }
        }
    }
}

extension MyPageViewModel {
    func getDownLoadImage(otherUser: UserModel?) {
        if otherUser == nil {
            if userSaveImage.0 != userManager.user?.profileURL ?? ""{
                guard let urlString = userManager.user?.profileURL else { return }
                if let url = URL(string: urlString) {
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                        guard error == nil else { return }
                        guard let imageData = data else { return }
                        print(imageData)
                        DispatchQueue.main.async {
                            self.userSaveImage = (urlString, UIImage(data: imageData) ?? UIImage(named: "Character")!)
                        }
                    }.resume()
                }
            }
        }
    }
}

