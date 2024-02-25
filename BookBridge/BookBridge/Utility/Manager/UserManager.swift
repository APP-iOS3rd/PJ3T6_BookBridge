//
//  UserManager.swift
//  BookBridge
//
//  Created by 이민호 on 2/7/24.
//

import Foundation
import Firebase
import FirebaseAuth
import KakaoSDKAuth
import KakaoSDKUser

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
    @Published var isChanged = false
    var uid = ""
    var user: UserModel?
    var currentUser: Firebase.User?
    
    func setUser(uid: String) {
        self.uid = uid
    }
    
    func login(uid: String) {
        self.uid = uid
        self.isLogin = true
        
        FirestoreManager.updateFCMToken(forUser: uid) { success in
            if success {
                print("FCM 토큰이 성공적으로 갱신되었습니다.")
            } else {
                print("FCM 토큰 갱신에 실패했습니다.")
            }
        }
        
        FirestoreManager.fetchUserModel(uid: uid) { user in
            self.user = user
            print("사용자가 login에 성공하였습니다.")
            print(user ?? "user가 없습니다.")
            self.currentDong = user?.getSelectedLocation()?.dong ?? ""
            self.isChanged.toggle()
        }
        
    }
    
    func logout() {
        self.uid = ""
        self.isLogin = false
        self.user = nil
        self.currentUser = nil
        try? Auth.auth().signOut()
        NaverAuthManager.shared.doNaverLogout()
        print("사용자가 logout하였습니다.")
    }
    
    func chageLocation(locations: [Location]) {
        user?.location = locations
        currentDong = user?.getSelectedLocation()?.dong ?? ""
        self.isChanged.toggle()
    }
    
    func deleteUserAccount(completion: @escaping (Bool) -> Void) {
        
        guard let user = Auth.auth().currentUser else {
            print("로그인된 사용자가 없습니다.")
            completion(false)
            return
        }
        
        // Firebase Authentication에서 사용자 계정 삭제
        user.delete { error in
            if let error = error as? NSError {
                if error.code == AuthErrorCode.requiresRecentLogin.rawValue {
                    // 재로그인 필요
                    completion(false)
                    print("재로그인 필요")
                } else {
                    print("계정 삭제 실패: \(error.localizedDescription)")
                    completion(false)
                }
                
            } else {
                print("계정이 성공적으로 삭제되었습니다.")
                UserApi.shared.unlink {(error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("unlink() success.")
                    }
                }
                NaverAuthManager.shared.oauth20ConnectionDidFinishDeleteToken()
                self.logout()
                completion(true)
            }
        }
        
        // Firebase Firestore에서 사용자 관련 데이터 삭제
        // 예: 사용자 프로필, 게시글 등
        FirestoreManager.deleteUserData(uid: user.uid) { success in
            if !success {
                print("Firestore에서 사용자 데이터 삭제 실패")
                completion(false)
                return
            }
        }
        FirestoreManager.deleteUserProfileImage(uid: user.uid) { success in
            guard success else {
                print("Storage에서 프로필 이미지 삭제 실패")
                completion(false)
                return
            }
        }
        

    }
}
