//
//  KakaoLoginViewModel.swift
//  BookBridge
//
//  Created by 김건호 on 1/26/24.
//

import Foundation
import FirebaseAuth
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

class KakaoLoginViewModel : ObservableObject {
    @Published var state: SignInState = .signedOut
    
    enum SignInState{
        case signedIn
        case signedOut
    }
    
    func emailAuthSignUp(email: String, userName: String, password: String, completion: (() -> Void)?) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
            }
            if result != nil {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = userName
                print("사용자 이메일: \(String(describing: result?.user.email))")
            }
            
            completion?()
        }
    }
    
    func emailAuthSignIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            if result != nil {
                self.state = .signedIn
                print("사용자 이메일: \(String(describing: result?.user.email))")
                
            }
        }
    }
    
    
    // MARK: - KakaoAuth SignIn Function
    func kakaoAuthSignIn() {
        if AuthApi.hasToken() { // 발급된 토큰이 있는지
            UserApi.shared.accessTokenInfo { _, error in // 해당 토큰이 유효한지
                if let error = error { // 에러가 발생했으면 토큰이 유효하지 않다.
                    self.openKakaoService()
                } else { // 유효한 토큰
                    self.loadingInfoDidKakaoAuth()
                }
            }
        } else { // 만료된 토큰
            self.openKakaoService()
        }
    }
    
    func openKakaoService() {
        if UserApi.isKakaoTalkLoginAvailable() { // 카카오톡 앱 이용 가능한지
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in // 카카오톡 앱으로 로그인
                if let error = error { // 로그인 실패 -> 종료
                    print("Kakao Sign In Error: ", error.localizedDescription)
                    return
                }
                
                _ = oauthToken // 로그인 성공
                self.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
            }
        } else { // 카카오톡 앱 이용 불가능한 사람
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in // 카카오 웹으로 로그인
                if let error = error { // 로그인 실패 -> 종료
                    print("Kakao Sign In Error: ", error.localizedDescription)
                    return
                }
                _ = oauthToken // 로그인 성공
                self.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
            }
        }
    }
    
    func loadingInfoDidKakaoAuth() {  // 사용자 정보 불러오기
        UserApi.shared.me { kakaoUser, error in
            if let error = error {
                print("카카오톡 사용자 정보 불러오는데 실패했습니다.")
                
                return
            }
            guard let email = kakaoUser?.kakaoAccount?.email else { return }
            guard let password = kakaoUser?.id else { return }
            guard let userName = kakaoUser?.kakaoAccount?.profile?.nickname else { return }            
            
            self.emailAuthSignUp(email: email, userName: userName, password: "\(password)") {
                self.emailAuthSignIn(email: email, password: "\(password)")
            }
        }
    }
    
    // 로그아웃 기능 추가
    func logout() {
        // Firebase 로그아웃
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Firebase 로그아웃 실패: \(signOutError.localizedDescription)")
        }

        // Kakao 로그아웃
        UserApi.shared.logout { (error) in
            if let error = error {
                print("Kakao 로그아웃 실패: \(error.localizedDescription)")
            }
        }

        self.state = .signedOut
        
    }
    
}


