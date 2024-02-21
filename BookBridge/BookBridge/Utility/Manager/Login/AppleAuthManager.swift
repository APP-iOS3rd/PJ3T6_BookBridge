//
//  AppleAuthManager.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/01/30.
//

import Foundation
import AuthenticationServices
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import FirebaseMessaging

class AppleAuthManager: NSObject, ASAuthorizationControllerDelegate, ObservableObject {
    @Published var isSignedIn = false
    
    // 상태 변경을 알리기 위한 클로저
    var didChangeSignInStatus: ((Bool) -> Void)?
    
    // 애플 로그인 시작
    func startSignInWithAppleFlow() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
    
    //애플로그인 컨트롤
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let appleIDToken = appleIDCredential.identityToken,
           let idTokenString = String(data: appleIDToken, encoding: .utf8) {
            
            // Apple ID 자격증명
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nil, fullName: appleIDCredential.fullName)
            
            //  Firebase에 사용자 인증 요청
            Auth.auth().signIn(with: credential) { (authResult, error) in
                
                if let error = error {
                    print("Firebase 로그인 실패: \(error.localizedDescription)")
                    
                    DispatchQueue.main.async {
                        self.didChangeSignInStatus?(false)
                    }
                    
                    return
                }
                
                if let user = authResult?.user{
                
                    // FCM 토큰 가져오기
                    FCMTokenManager.shared.fetchFCMToken{ fcmToken in
                        
                        FirestoreSignUpManager.shared.getUserData(email: user.email ?? "") { userData in
                            if userData != nil {
                                // 로그인
                                UserManager.shared.login(uid: user.uid)
                            } else {
                                guard let email = user.email else {return}
                                // 회원가입
                                FirestoreSignUpManager.shared.addUser(id: user.uid, email: email, password: nil, nickname: nil, phoneNumber: nil, fcmToken: fcmToken){
                                    UserManager.shared.login(uid: user.uid)
                                }
                      
                            }
                        }
                    }
                    
                    
                    DispatchQueue.main.async {
                        self.isSignedIn = true
                        self.didChangeSignInStatus?(true)
                    }
                }
            }
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            DispatchQueue.main.async {
                print("Apple Login Failed: \(error.localizedDescription)")
                self.didChangeSignInStatus?(false)
            }
        }
    }
}

