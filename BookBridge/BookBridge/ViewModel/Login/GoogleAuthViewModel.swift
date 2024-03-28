//
//  GoogleAuthViewModel.swift
//  BookBridge
//
//  Created by 이민호 on 2/1/24.
//

import Foundation
import SwiftUI

final class GoogleAuthViewModel: ObservableObject {
    @Published var isLogin = false
    
    func signInGoogle() async throws {
        let helper = GoogleSignManager()
        let tokens = try await helper.signIn()
        do {
            let result = try await GoogleAuthManager.shared.signInWithGoogle(tokens: tokens)
            guard let email = result.email else { return }
            
            // FCM 토큰 가져오기
            FCMTokenManager.shared.fetchFCMToken { fcmToken in
                FirestoreSignUpManager.shared.getUserData(email: email) { userData in
                    if userData != nil {
                        // 로그인
                        UserManager.shared.login(uid: result.uid)
                        self.isLogin.toggle()
                    } else {
                        // 회원가입
                        FirestoreSignUpManager.shared.addUser(id: result.uid, email: email, password: "", nickname: "", phoneNumber: "", fcmToken: fcmToken) {
                            UserManager.shared.login(uid: result.uid)
                            self.isLogin.toggle()
                        }
                    }
                }
            }
 
        } catch let err {
            print(err.localizedDescription)
        }
    }
}
