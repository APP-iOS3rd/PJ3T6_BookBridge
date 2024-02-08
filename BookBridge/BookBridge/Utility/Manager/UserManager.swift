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
    
    var uid = "Xy8rRkI7XiQvs3xR50BAflW2aXu2"
    
    func setUser(uid: String) {
        self.uid = uid
    }
}

