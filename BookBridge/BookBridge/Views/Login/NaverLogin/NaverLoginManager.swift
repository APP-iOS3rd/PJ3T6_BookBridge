//
//  NaverLoginManager.swift
//  BookBridge
//
//  Created by 노주영 on 1/29/24.
//

import Foundation
import NaverThirdPartyLogin

class NaverLoginManager : NSObject {
    static let shared = NaverLoginManager()
    
    func doNaverLogin() {
        NaverThirdPartyLoginConnection.getSharedInstance().delegate = self
                   NaverThirdPartyLoginConnection
                       .getSharedInstance()
                       .requestThirdPartyLogin()
    }
    
    func doNaverLogout() {
        NaverThirdPartyLoginConnection.getSharedInstance().requestDeleteToken()
        //NaverThirdPartyLoginConnection.getSharedInstance().resetToken()
    }
}

extension NaverLoginManager : UIApplicationDelegate, NaverThirdPartyLoginConnectionDelegate {
    // 토큰 발급 성공시
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("성공")
        print(NaverThirdPartyLoginConnection.getSharedInstance().accessToken ?? "")
    }
    
    // 토큰 갱신시
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        
    }
    
    // 로그아웃(토큰 삭제)시
    func oauth20ConnectionDidFinishDeleteToken() {
        print("로그아웃")
    }
    
    // Error 발생
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print(error!)
    }
}
