//
//  FirestoreProtocol.swift
//  BookBridge
//
//  Created by 이민호 on 3/5/24.
//

import Combine
import Foundation
import FirebaseFirestore

protocol FirestoreFindable {
    
}

extension FirestoreFindable {
    
    func checkEmailExists(email: String) -> AnyPublisher<Bool, Error> {
        let db = Firestore.firestore()
        
        return Future<Bool, Error> { promise in
            // Firestore 콜렉션 참조
            let usersRef = db.collection("User")
            
            // 이메일 및 비밀번호 확인
            usersRef.whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("해당 이메일과 같은 이메일 문서를 찾을 수 없습니다.: \(error)")
                    promise(.failure(error))
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    promise(.success(false)) // 문서가 없음
                    return
                }
                
                // 이메일과 비밀번호 확인
                for document in documents {
                    if let userEmail = document.data()["email"] as? String,
                       let userPassword = document.data()["password"] as? String {
                        
                        // 이메일이 일치하고 비밀번호가 비어있지 않은지 확인
                        if userEmail == email && !userPassword.isEmpty {
                            promise(.success(true)) // 이메일과 비밀번호가 일치함
                            return
                        }
                    }
                }
                
                // 이메일 또는 비밀번호가 일치하지 않음
                promise(.success(false))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func checkPhoneNumberExists(phoneNumber: String) -> AnyPublisher<Bool, Error> {
        let db = Firestore.firestore()
        
        return Future<Bool, Error> { promise in
            // 'User' 컬렉션 참조
            let usersRef = db.collection("User")
            
            // phoneNumber 확인
            usersRef.whereField("phoneNumber", isEqualTo: phoneNumber)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    
                    // querySnapshot에서 문서가 없으면 phoneNumber가 존재하지 않음
                    guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                        promise(.success(false))
                        return
                    }
                    
                    // phoneNumber가 존재함
                    promise(.success(true))
                }
        }
        .eraseToAnyPublisher()
    }
    
    func findUserID(email: String, phoneNumber: String) -> AnyPublisher<String?, Error> {
        let db = Firestore.firestore()
        
        return Future<String?, Error> { promise in
            let usersRef = db.collection("User")
            
            usersRef.whereField("email", isEqualTo: email)
                .whereField("phoneNumber", isEqualTo: phoneNumber)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        guard let documents = querySnapshot?.documents else {
                            promise(.success(nil)) // No matching document found
                            return
                        }
                        
                        if let document = documents.first {
                            promise(.success(document.documentID)) // Return the document ID
                        } else {
                            promise(.success(nil)) // No matching document found
                        }
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}

