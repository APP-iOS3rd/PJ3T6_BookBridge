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
    var firestoreListener: ListenerRegistration?
    
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
    @Published var isDoSignUp = false
    @Published var isWishStyleCheck = false
    @Published var isHoldStyleCheck = false
    @Published var totalNewCount = 0
    
    var uid = ""
    var user: UserModel?
    var currentUser: Firebase.User?
    var reportedTargetIds: Set<String> {
         ReportedContentsManager.shared.reportedTargetIds
     }
    
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
    
    func resetLoginState() {
        if currentUser != nil {
            self.logout()
            print("LOGOUT")
        }
    }
    
    func logout() {
        self.uid = ""
        self.isLogin = false
        self.user = nil
        self.currentUser = nil
        self.totalNewCount = 0
        self.firestoreListener?.remove()
        try? Auth.auth().signOut()
        NaverAuthManager.shared.doNaverLogout()
        print("사용자가 logout하였습니다.")
    }
    
    func chageLocation(locations: [Location]) {
        user?.location = locations
        currentDong = user?.getSelectedLocation()?.dong ?? ""
        self.isChanged.toggle()
    }
    
    func deleteUserAccount(completion: @escaping (Bool, String) -> Void) {
        
        guard let user = Auth.auth().currentUser else {
            completion(false, "로그인된 사용자가 없습니다.")
            return
        }
        
        user.delete { error in
            if let error = error as? NSError {
                if error.code == AuthErrorCode.requiresRecentLogin.rawValue {
                    self.resetLoginState()
                    completion(false, "재로그인 후 다시 시도해주세요.")
                    print("재로그인이 필요합니다.")
                } else {
                    completion(false, "계정 삭제 실패: \(error.localizedDescription)")
                }
            } else {
                // 계정이 성공적으로 삭제된 후 Firestore 및 Storage 데이터 삭제
                FirestoreManager.deleteUserData(uid: user.uid) { _ in
                    FirestoreManager.deleteUserProfileImage(uid: user.uid) { _ in
                        // Firestore 및 Storage 삭제의 결과와 상관없이 계정 삭제 성공 처리
                        print("계정이 성공적으로 삭제되었습니다.")
                        UserApi.shared.unlink { error in
                            if let error = error {
                                print("Kakao unlink error: \(error)")
                            } else {
                                print("unlink() success.")
                            }
                        }
                        NaverAuthManager.shared.oauth20ConnectionDidFinishDeleteToken()
                        self.logout()
                        completion(true, "성공")
                    }
                }
            }
        }
    }
    
    func updateTotalNewCount() {
        if uid != "" {
            firestoreListener?.remove()
            firestoreListener = FirebaseManager.shared.firestore.collection("User").document(uid).collection("chatRoomList").whereField("newCount", isGreaterThan: 0).addSnapshotListener { querySnapshot, error in
                guard error == nil else { return }
                guard let documents = querySnapshot?.documents else { return }
                self.totalNewCount = 0
                for document in documents {
                    
                    //신고된 채팅방 Count제외
                    if !self.reportedTargetIds.contains(document.documentID){
                        self.totalNewCount += document.data()["newCount"] as? Int ?? 0
                    }
                }
                UIApplication.shared.applicationIconBadgeNumber = self.totalNewCount
            }
        }
    }
}
