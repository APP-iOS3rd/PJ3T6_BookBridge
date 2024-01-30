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

@main
struct BookBridgeApp: App {
    
    init() {
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: "3faeb18730ff6edf468b5e43fc5fea19")
    }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            EmailCertiView()
//            LoginView()
//                .onOpenURL { url in // 뷰가 속한 Window에 대한 URL을 받았을 때 호출할 Handler를 등록하는 함수
//                    if AuthApi.isKakaoTalkLoginUrl(url) {
//                        _ = AuthController.handleOpenUrl(url: url)
//                    }
//                }
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
