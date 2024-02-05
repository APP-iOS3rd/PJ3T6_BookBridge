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
import FirebaseFirestore

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
    
    func emailAuthSignIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                completion(false)
                return
            }
            if result != nil {
                self.state = .signedIn
                print("사용자 이메일: \(String(describing: result?.user.email))")
                completion(true)
            } else {
                completion(false)
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
    
//    func loadingInfoDidKakaoAuth() {  // 사용자 정보 불러오기
//        UserApi.shared.me { kakaoUser, error in
//            if let error = error {
//                print("카카오톡 사용자 정보 불러오는데 실패했습니다.")
//
//                return
//            }
//            guard let email = kakaoUser?.kakaoAccount?.email else { return }
//            guard let password = kakaoUser?.id else { return }
//            guard let userName = kakaoUser?.kakaoAccount?.profile?.nickname else { return }
//
//            self.emailAuthSignUp(email: email, userName: userName, password: "\(password)") {
//                self.emailAuthSignIn(email: email, password: "\(password)")
//            }
//        }
//    }
//    func loadingInfoDidKakaoAuth() {
//        UserApi.shared.me { kakaoUser, error in
//            if let error = error {
//                print("카카오톡 사용자 정보 불러오는데 실패했습니다.")
//                return
//            }
//            guard let email = kakaoUser?.kakaoAccount?.email else { return }
//            let password = String(kakaoUser?.id ?? 0) // Kakao ID를 비밀번호로 사용
//            guard let userName = kakaoUser?.kakaoAccount?.profile?.nickname else { return }
//
//            self.emailAuthSignUp(email: email, userName: userName, password: "\(password)") {
//                            self.emailAuthSignIn(email: email, password: "\(password)")
//            }
//            //Auth에서 찾고 -> Auth에서 접ㄱ
//            FirestoreSignUpManager.shared.checkIfUserExists(email: email) { exists in
//                if exists {
//                    // 사용자가 존재함, 로그인 처리
//                    self.emailAuthSignIn(email: email, password: password)
//                        // 로그인 성공 후 Firestore에서 사용자 정보 가져오기
//                        FirestoreSignUpManager.shared.getUserData(email: email) { userData in
//                            if let userData = userData {
//                                // 사용자 정보 처리
//                                print("HELLO")
//                                print(userData)
//                                self.state = .signedIn
//                            } else {
//                                // 사용자 데이터를 찾을 수 없음. 필요한 경우 오류 처리
//                                print("ERROR")
//                            }
//                        }
//
//                } else {
//                    // 사용자가 존재하지 않으면 새로 등록
//                    FirestoreSignUpManager.shared.register(email: email, password: password, nickname: userName) {
//                        self.state = .signedIn
//                        // 필요한 경우 추가적인 처리 수행
//                    }
//                }
//            }
//        }
//    }
    
    func loadingInfoDidKakaoAuth() {
        UserApi.shared.me { kakaoUser, error in
            if let error = error {
                print("카카오톡 사용자 정보 불러오는데 실패했습니다.", error.localizedDescription)
                return
            }
            guard let email = kakaoUser?.kakaoAccount?.email,
                  let password = kakaoUser?.id.map(String.init),
                  let userName = kakaoUser?.kakaoAccount?.profile?.nickname else { return }

            self.emailAuthSignIn(email: email, password: password) { success in
                if success {
                    // 로그인 성공
                    FirestoreSignUpManager.shared.getUserData(email: email) { userData in
                        if let userData = userData {
                            // 사용자 정보 처리
                            print(userData)
                            self.state = .signedIn
                        } else {
                            // 사용자 데이터를 찾을 수 없음. 필요한 경우 오류 처리
                            print("ERROR")
                        }
                    }
                } else {
                    // 로그인 실패, 새 사용자 등록
                    FirestoreSignUpManager.shared.register(email: email, password: password, nickname: userName) {
                        FirestoreSignUpManager.shared.getUserData(email: email) { userData in
                            if let userData = userData {
                                // 사용자 정보 처리                                
                                print(userData)
                                self.state = .signedIn
                            } else {
                                // 사용자 데이터를 찾을 수 없음. 필요한 경우 오류 처리
                                print("ERROR")
                            }
                        }
                    }
                }
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

