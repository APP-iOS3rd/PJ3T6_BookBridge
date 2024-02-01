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
            
    func isValidEmail(email: String) -> Bool {
        var result = false
        
        let userDB = db.collection("User")
        let query = userDB.whereField("id", isEqualTo: email)
        
        query.getDocuments() { (qs, err) in
            
            if qs!.documents.isEmpty {
                print("이메일 중복 없음")
                result = true
            } else {
                print("이메일 중복")
            }
        }
        
        return result
    }
    
    func isValidId(id: String) -> Bool {
        var result = false
        
        let userDB = db.collection("User")
        let query = userDB.whereField("loginId", isEqualTo: id)
        query.getDocuments() { (qs, err) in
            
            if qs!.documents.isEmpty {
                print("아이디 중복 없음")
                result = true
            } else {
                print("아이디 중복")
            }
        }
        
        return result
    }
    
    func isValidNickname(nickname: String) -> Bool {
        var result = false
        
        let userDB = db.collection("User")
        let query = userDB.whereField("nickname", isEqualTo: nickname)
        query.getDocuments() { (qs, err) in
            
            if qs!.documents.isEmpty {
                print("닉네임 중복 없음")
                result = true
            } else {
                print("닉네임 중복")
            }
        }
        
        return result
    }
        
}
