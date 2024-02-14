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
    
    var uid = ""
    var isLogin = false
    
    func setUser(uid: String) {
        self.uid = uid
    }
    
    func login(uid: String) {
        self.uid = uid
        self.isLogin = true
    }
    
    func logout() {
        self.uid = ""
        self.isLogin = false
    }
}
