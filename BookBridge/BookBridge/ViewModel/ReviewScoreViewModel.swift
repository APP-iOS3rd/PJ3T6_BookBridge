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
        
        self.mannerScore =  Int((Double(reviews[0] * 3)) / Double(((reviews[0] * 3) + (reviews[1] * 2) + (reviews[2] * 1))) * 100)
    }
}
