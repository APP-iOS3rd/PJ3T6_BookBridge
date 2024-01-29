//
//  NaverLoginManager.swift
//  BookBridge
//
//  Created by 노주영 on 1/29/24.
//

import Foundation
import Alamofire
import FirebaseAuth
import NaverThirdPartyLogin

class NaverLoginManager : NSObject {
    static let shared = NaverLoginManager()
}

//네이버 로그인 인증
extension NaverLoginManager : UIApplicationDelegate, NaverThirdPartyLoginConnectionDelegate {
    func doNaverLogin() {
        NaverThirdPartyLoginConnection.getSharedInstance().delegate = self
                   NaverThirdPartyLoginConnection
                       .getSharedInstance()
                       .requestThirdPartyLogin()
    }
    
    func doNaverLogout() {
        NaverThirdPartyLoginConnection.getSharedInstance().resetToken()
    }
    
    // 토큰 발급 성공시
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("성공")
        getUserInfo()
    }
    
    // 토큰 갱신시
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        
    }
    
    // 토큰 삭제시
    func oauth20ConnectionDidFinishDeleteToken() {
        print("유저 정보 삭제")
    }
    
    // Error 발생
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print(error!)
    }
}

//네이버 정보 가져오기(Alamofire)
extension NaverLoginManager {
    func getUserInfo() {
        guard let tokenType = NaverThirdPartyLoginConnection.getSharedInstance().tokenType else { return }
        guard let accessToken = NaverThirdPartyLoginConnection.getSharedInstance().accessToken else { return }
        let url = "https://openapi.naver.com/v1/nid/me"
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: ["Authorization": "\(tokenType) \(accessToken)"]
        ).responseJSON { [weak self] response in
            guard let result = response.value as? [String: Any] else { return }
            guard let object = result["response"] as? [String: Any] else { return }
            
            guard let id = object["id"] as? String else { return }
            guard let nickname = object["nickname"] as? String else { return }
            guard let email = object["email"] as? String else { return }
            
            /*
            guard let name = object["name"] as? String else { return }
            guard let gender = object["gender"] as? String else { return }
            guard let age = object["age"] as? String else { return }
            guard let birthday = object["birthday"] as? String else { return }
            guard let profileimage = object["profile_image"] as? String else { return }
             */
            
            self?.emailAuthSignUp(email: email, userName: nickname, password: id) {
                self?.emailAuthSignIn(email: email, password: id)
            }
        }
    }
}

//Firebase Auth
extension NaverLoginManager {
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
                print("사용자 이메일: \(String(describing: result?.user.email))")
            }
        }
    }
}
