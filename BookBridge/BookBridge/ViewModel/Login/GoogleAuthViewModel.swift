//
//  GoogleAuthViewModel.swift
//  BookBridge
//
//  Created by 이민호 on 2/1/24.
//

import Foundation

final class GoogleAuthViewModel: ObservableObject {
    
    func signInGoogle() async throws {
        let helper = GoogleSignManager()
        let tokens = try await helper.signIn()
        do {
            let result = try await GoogleAuthManager.shared.signInWithGoogle(tokens: tokens)
            guard let email = result.email else { return }
            
            FirestoreSignUpManager.shared.getUserData(email: email) { userData in
                if userData != nil {
                    // 로그인
                    UserManager.shared.login(uid: result.uid)                    
                } else {
                    // 회원가입
                    FirestoreSignUpManager.shared.addUser(id: result.uid, email: email, password: nil, nickname: nil, phoneNumber: nil) {                        
                        UserManager.shared.login(uid: result.uid)
                    }                    
                }
            }
        } catch let err {
            print(err.localizedDescription)
        }
    }
}
