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
    @Published var userBookMarks: [String] = []
    @Published var userRequests: [String] = []
    @Published var userSaveImage: (String, UIImage) = ("", UIImage(named: "Character")!)
    
    let db = Firestore.firestore()
    let userManager = UserManager.shared
}

extension MyPageViewModel {
    func getUserInfo() {
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
    }
}

extension MyPageViewModel {
    func getDownLoadImage() {
        print("유저: \(userManager.user?.profileURL)")
        print("userSaveImage: \(userSaveImage)")
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

