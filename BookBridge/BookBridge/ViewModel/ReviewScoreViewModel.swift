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
    func getMannerScore(otherUser: UserModel?) {
        var reviews: [Int] = [0, 0, 0]
        
        if otherUser == nil {
            reviews = userManager.user?.reviews ?? [0, 0, 0]
        } else {
            reviews = otherUser?.reviews ?? [0, 0, 0]
        }
        
        guard reviews.count == 3 else { return }
        
        if reviews[0] == 0 && reviews[1] == 0 && reviews[2] == 0{
            self.mannerScore = -1
        } else {
            self.mannerScore =  Int((Double(reviews[0] * 3)) / Double(((reviews[0] * 3) + (reviews[1] * 2) + (reviews[2] * 1))) * 100)
        }
    }
}
