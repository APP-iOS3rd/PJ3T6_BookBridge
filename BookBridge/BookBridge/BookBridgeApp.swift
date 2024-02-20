//
//  BookBridgeApp.swift
//  BookBridge
//
//  Created by 이민호 on 1/25/24.
//

import SwiftUI
import Firebase
import KakaoSDKCommon
import KakaoSDKAuth
import NaverThirdPartyLogin

@main
struct BookBridgeApp: App {
            
    init() {

        //Kakao SDK 초기화
        if let kakaoAppKey = Bundle.main.KakaoAppKey {
            KakaoSDK.initSDK(appKey: kakaoAppKey)
        } else {
            print("kakaoAppKey를 찾을 수 없습니다.")
        }

        
        //Naver SDK 초기화
        NaverThirdPartyLoginConnection.getSharedInstance().isNaverAppOauthEnable = true // NaverApp 사용 로그인
        NaverThirdPartyLoginConnection.getSharedInstance()?.isInAppOauthEnable = true // 사파리 사용 로그인
        
        NaverThirdPartyLoginConnection.getSharedInstance().serviceUrlScheme = kServiceAppUrlScheme
        NaverThirdPartyLoginConnection.getSharedInstance().consumerKey = kConsumerKey
        NaverThirdPartyLoginConnection.getSharedInstance().consumerSecret = kConsumerSecret
        NaverThirdPartyLoginConnection.getSharedInstance().appName = kServiceAppName
    }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var pathModel = PathViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabBarView(userId: UserManager.shared.uid)
                .onOpenURL { url in // 뷰가 속한 Window에 대한 URL을 받았을 때 호출할 Handler를 등록하는 함수
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
                .onAppear() {
                    LocationViewModel.shared.checkIfLocationServiceIsEnabled()
                    NaverMapApiManager.getNaverApiInfo()
                    
                }
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        // Firebase 실행확인 print
        print("Configured Firebase!")
        
        return true
    }
}
