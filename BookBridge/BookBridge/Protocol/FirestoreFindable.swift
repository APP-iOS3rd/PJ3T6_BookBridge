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
    
    func findUserIdWithPhone(phoneNumber: String) -> AnyPublisher<String?, Error> {
        let db = Firestore.firestore()
        
        return Future<String?, Error> { promise in
            let usersRef = db.collection("User")
            
            usersRef.whereField("phoneNumber", isEqualTo: phoneNumber)
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
    
    func fetchEmailFromUser(documentId: String) -> AnyPublisher<String, Error> {
        // Firestore에서 User 콜렉션의 특정 문서 ID에 접근        
        let docRef = Firestore.firestore().collection("User").document(documentId)
        
        return Future<String, Error> { promise in
            docRef.getDocument { document, error in
                if let error = error {
                    // 오류 발생 시, promise로 오류 전달
                    promise(.failure(error))
                } else {
                    // 문서에서 email 필드를 가져옴
                    if let email = document?.data()?["email"] as? String {
                        // 성공적으로 email을 가져옴, promise로 email 전달
                        promise(.success(email))
                    } else {
                        // email 필드가 없을 경우, 오류 전달
                        promise(.failure(NSError(domain: "EmailNotFound", code: 404, userInfo: nil)))
                    }
                }
            }
        }.eraseToAnyPublisher() // Future를 AnyPublisher로 변환
    }
}

