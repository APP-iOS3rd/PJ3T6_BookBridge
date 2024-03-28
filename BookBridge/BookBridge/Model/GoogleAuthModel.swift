//
//  GoogleAuthModel.swift
//  BookBridge
//
//  Created by 이민호 on 2/1/24.
//

import Foundation
import FirebaseAuth

struct GoogleAuthModel {
    let uid: String
    let email: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
    }
}
