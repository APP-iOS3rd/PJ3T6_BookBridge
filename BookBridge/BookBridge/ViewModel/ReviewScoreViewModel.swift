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
    
    let db = Firestore.firestore()
    let userManager = UserManager.shared
}

extension ReviewScoreViewModel {
    func getMannerScore() {
        guard let reviews = userManager.user?.reviews else { return }
        
        guard reviews.count == 3 else {
            return
        }
        
        let totalReviews = reviews.reduce(0, +)
        
        // 모든 리뷰가 0인 경우에는 0으로 반환
        guard totalReviews > 0 else {
            return
        }
        
        let weightedSum = 3 * reviews[0] + 2 * reviews[1] + 1 * reviews[2]
        
        // 다른 가중치를 부여하여 평점 계산
        let rating = Int(Double(weightedSum) / Double(totalReviews) * 100)
        
        self.mannerScore = Int(rating * 100) // 백분율로 표시하기 위해 100을 곱함
                
        // self.mannerScore =  Int((Double(reviews[0] * 3)) / Double(((reviews[0] * 3) + (reviews[1] * 2) + (reviews[2] * 1))) * 100)
    }
}
