//
//  FirebaseStyleManager.swift
//  BookBridge
//
//  Created by 노주영 on 2/8/24.
//

import Foundation
import FirebaseFirestore

class FirebaseStyleManager {
    static let shared = FirebaseStyleManager()

    private init() {}
    
    let db = Firestore.firestore()
}

extension FirebaseStyleManager {
    func getMyStyle(userId: String, completion: @escaping([String]) -> ()) {
        var styleList: [String] = []
        
        db.collection("User").document(userId).collection("style").getDocuments { querySnapshot, error in
            guard error == nil else { return }
            guard let documents = querySnapshot?.documents else { return }
            
            for document in documents {
                styleList.append(document.data()["title"] as? String ?? "")
            }
            completion(styleList)
        }
    }
    
    func changeSelectedStyle(userId: String, style: String) {
        db.collection("User").document(userId).updateData([
            "style": style
        ])
    }
}
