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
    
    var uid = "LXZQd1GmWOYFpxmRtoW4WpLS8Uy2"
    var user: UserModel?
    
    var isLogin = false
    
    func setUser(uid: String) {
        self.uid = uid
    }
    
    func login(uid: String) {
        self.uid = uid
        self.isLogin = true
        FirestoreManager.fetchUserModel(uid: uid) { user in
            self.user = user
            print("사용자가 login에 성공하였습니다.")
            print(user ?? "user가 없습니다.")
        }
    }
    
    func logout() {
        self.uid = ""
        self.isLogin = false
        self.user = nil
        print("사용자가 logout하였습니다.")
    }
}
