//
//  ReviewScoreViewModel.swift
//  BookBridge
//
//  Created by 노주영 on 2/13/24.
//

import Foundation
import FirebaseFirestore

class ReviewScoreViewModel: ObservableObject {
    @Published var mannerScore: Int = 0
    @Published var review0: Int = 0
    @Published var review1: Int = 0
    @Published var review2: Int = 0
    
    let db = Firestore.firestore()
    let userManager = UserManager.shared
    var listener: ListenerRegistration?
}

extension ReviewScoreViewModel {
    
    func listenForReviewUpdates(userId: String){
        //기존 리스너 제거
        listener?.remove()
        
        // 특정 사용자의 리뷰 데이터에 대한 리스너 설정
        listener = db.collection("User").document(userId).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Firestore error: \(error?.localizedDescription ?? "No error description")")
                return
            }
            
            // reviews 데이터가 업데이트 되면 점수 재정의 및 mannerScore 재계산
            if let reviews = document.data()?["reviews"] as? [Int], reviews.count == 3 {
                self.updateReview(reviews: reviews)
            }
        }
    }
}

extension ReviewScoreViewModel {
    func updateReview(reviews: [Int]) {
        if reviews[0] == 0 && reviews[1] == 0 && reviews[2] == 0{
            self.mannerScore = -1
        } else {
            self.review0 = Int(reviews[0])
            self.review1 = Int(reviews[1])
            self.review2 = Int(reviews[2])
            self.mannerScore =  Int((Double(reviews[0] * 3)) / Double(((reviews[0] * 3) + (reviews[1] * 2) + (reviews[2] * 1))) * 100)
        }
    }
}
