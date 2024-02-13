//
//  UserManager.swift
//  BookBridge
//
//  Created by 이민호 on 2/7/24.
//

import Foundation

class UserManager {
    static let shared = UserManager()
    private init() {}
    
    var uid = "38HP0OGCEpY9cpwjknZqflX1Jsy1"
    
    func setUser(uid: String) {
        self.uid = uid
    }
}

