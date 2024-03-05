//
//  FirestoreProtocol.swift
//  BookBridge
//
//  Created by 이민호 on 3/5/24.
//

import Foundation
import Combine
import FirebaseFirestore

protocol FirestoreFindable {
    
}

extension FirestoreFindable {
    
    
    func checkEmailExists(email: String) -> AnyPublisher<Bool, Error> {
        let db = Firestore.firestore()
        
        return Future<Bool, Error> { promise in
            let usersRef = db.collection("User")
            
            usersRef.whereField("email", isEqualTo: email)
                    .whereField("isSNS", isEqualTo: false)
                    .getDocuments { (querySnapshot, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    if let documents = querySnapshot?.documents, !documents.isEmpty {
                        promise(.success(true)) // 이메일이 존재함
                    } else {
                        promise(.success(false)) // 이메일이 존재하지 않음
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
