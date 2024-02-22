//
//  ReviewScoreViewModel.swift
//  BookBridge
//
//  Created by 노주영 on 2/13/24.
//

import Foundation
import FirebaseFirestore

class ReviewScoreViewModel: ObservableObject {
    @Published var userReviewArr: [Int] = [0, 0, 0]
    @Published var mannerScore: Int = 0
    
    let db = Firestore.firestore()
}

extension ReviewScoreViewModel {
    func getReviewsScore(userId: String, completion: @escaping([Int]) -> ()) {
        db.collection("user").document(userId).collection("reviews").getDocuments { querySnapshot, error in
            guard error == nil else { return }
            guard let documents = querySnapshot?.documents else { return }
            
            for document in documents {
                switch document.documentID {
                case "high":
                    self.userReviewArr[0] = document.data()["score"] as? Int ?? 0
                case "middle":
                    self.userReviewArr[1] = document.data()["score"] as? Int ?? 0
                default:
                    self.userReviewArr[2] = document.data()["score"] as? Int ?? 0
                }
            }
            completion(self.userReviewArr)
        }
    }
    
    func getMannerScore() {
        self.mannerScore =  Int((Double(self.userReviewArr[0] * 3)) / Double(((self.userReviewArr[0] * 3) + (self.userReviewArr[1] * 2) + (self.userReviewArr[2] * 1))) * 100)
    }
}
