//
//  UserManager.swift
//  BookBridge
//
//  Created by 이민호 on 2/7/24.
//

import Foundation
import Firebase
import FirebaseAuth

class UserManager: ObservableObject {
    static let shared = UserManager()
    private init() {
        currentUser = Auth.auth().currentUser
        if let userdata = currentUser {
            self.uid = userdata.uid
            login(uid: userdata.uid)
        }
    }
    
    @Published var currentDong = ""
    @Published var isLogin = false
    var uid = ""
    var user: UserModel?
    var currentUser: Firebase.User?
                    
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
            self.currentDong = user?.getSelectedLocation()?.dong ?? ""
        }
    }
    
    func logout() {
        self.uid = ""
        self.isLogin = false
        self.user = nil
        self.currentUser = nil
        try? Auth.auth().signOut()
        print("사용자가 logout하였습니다.")
    }
    
    func chageLocation(locations: [Location]) {
        user?.location = locations
        currentDong = user?.getSelectedLocation()?.dong ?? ""
    }
}
