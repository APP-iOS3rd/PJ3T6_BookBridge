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
    @Published var userId : String? = nil
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    
    func emailAuthSignUp(email: String, userName: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error as NSError? {
                if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    // 이미 존재하는 이메일
                    print("이미 사용 중인 이메일입니다.")
                    completion(false, "이미 사용 중인 이메일입니다.")
                } else {
                    // 다른 종류의 오류
                    print("error: \(error.localizedDescription)")
                    completion(false, error.localizedDescription)
                }
                return
            }
            if result != nil {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = userName
                changeRequest?.commitChanges { (error) in
                    if let error = error {
                        print("사용자 프로필 업데이트 실패: \(error.localizedDescription)")
                        completion(false, error.localizedDescription)
                        return
                    }
                    print("사용자 이메일: \(String(describing: result?.user.email))")
                    completion(true, nil)
                }
            }
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
                self.userId = result?.user.uid
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
    
    func kakaoUnlink() {
        UserApi.shared.unlink { (error) in
            if let error = error {
                print("Kakao 계정 연결 해제 실패: \(error.localizedDescription)")
            } else {
                print("Kakao 계정 연결 해제 성공. 토큰이 삭제되었습니다.")
            }
        }
    }
    
    
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
                        if let userData = userData, let uid = userData["id"] as? String {
                            // 사용자 정보 처리
                            self.state = .signedIn
                            self.userId = uid
                            UserManager.shared.login(uid: uid)
                            
                        } else {
                            // 사용자 데이터를 찾을 수 없음. 필요한 경우 오류 처리
                            print("ERROR")
                        }
                    }
                } else {
                    // 로그인 실패, 새 사용자 등록
                    FirestoreSignUpManager.shared.register(email: email, password: password, nickname: userName) { success, errorMessage in
                        if success{
                            FirestoreSignUpManager.shared.getUserData(email: email) { userData in
                                if let userData = userData, let uid = userData["id"] as? String {
                                    // 사용자 정보 처리
                                    self.state = .signedIn
                                    self.userId = uid
                                    UserManager.shared.login(uid: uid)
                                    
                                } else {
                                    // 사용자 데이터를 찾을 수 없음. 필요한 경우 오류 처리
                                    print("ERROR")
                                }
                            }
                        } else {
                            self.showAlert = true
                            if errorMessage == "The email address is already in use by another account." {
                                self.alertMessage = "이미 가입된 이메일입니다."
                            }                            
                            print(errorMessage ?? "알 수 없는 오류가 발생했습니다.")
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

