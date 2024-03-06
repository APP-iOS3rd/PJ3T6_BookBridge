//
//  FirestoreUpdatable.swift
//  BookBridge
//
//  Created by 이민호 on 3/6/24.
//

import Combine
import Foundation
import FirebaseFirestore

protocol FirestoreUpdatable {
    
}

extension FirestoreUpdatable {
    
    func updatePassword(userDocId: String, newPassword: String) -> AnyPublisher<Void, Error> {
        let db = Firestore.firestore()
        
        let userRef = db.collection("User").document(userDocId)
        
        return Future<Void, Error> { promise in
            userRef.updateData(["password": newPassword]) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
