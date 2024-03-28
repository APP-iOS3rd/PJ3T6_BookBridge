//
//  RedundantValidator.swift
//  BookBridge
//
//  Created by 이민호 on 1/31/24.
//

import Foundation
import Firebase
import FirebaseFirestore

struct RedundantValidator {
    let db = Firestore.firestore()
            
    
    func isValidEmail(email: String, completion: @escaping(Bool) -> Void) {
        let userDB = db.collection("User")
        let query = userDB.whereField("email", isEqualTo: email)
                
        query.getDocuments() { (qs, err) in
            if qs!.documents.isEmpty {
                print("이메일 중복 없음")
                completion(true)
            } else {
                print("이메일 중복")
                completion(false)
            }
        }        
    }
           
    func isValidNickname(nickname: String, completion: @escaping(Bool) -> Void) {
        let userDB = db.collection("User")
        let query = userDB.whereField("nickname", isEqualTo: nickname)
        
        query.getDocuments() { (qs, err) in
            
            if qs!.documents.isEmpty {
                print("닉네임 중복 없음")
                completion(true)
            } else {
                print("닉네임 중복")
                completion(false)
            }
        }
    }
    
//    static func isValidNickname(nickname: String) async throws -> Bool {
//        let snapshot = try await db.whereField("nickname", isEqualTo: nickname)
//    }
        
}
