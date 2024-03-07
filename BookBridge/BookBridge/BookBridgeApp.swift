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
import FirebaseMessaging

@main
struct BookBridgeApp: App {
    @AppStorage("OnBoarding") var isOnBoarding: Bool = true
    
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
    @StateObject private var locationViewModel = LocationViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            if isOnBoarding {
                LaunchScreenView(isOnboardingActive: $isOnBoarding)
            }
            else {
                TabBarView(userId: UserManager.shared.uid)
                    .onOpenURL { url in // 뷰가 속한 Window에 대한 URL을 받았을 때 호출할 Handler를 등록하는 함수
                        if AuthApi.isKakaoTalkLoginUrl(url) {
                            _ = AuthController.handleOpenUrl(url: url)
                        }
                    }
                    .onAppear() {
                        locationViewModel.checkIfLocationServiceIsEnabled()
                        NaverMapApiManager.getNaverApiInfo()
                    }
                //                .alert(isPresented: $locationViewModel.showLocationAlert) {
                //                    Alert(
                //                        title: Text("알림"),
                //                        message: Text("위치권한 거부로 앱이 종료됩니다."),
                //                        dismissButton: .default(Text("확인"), action: {
                //
                //                        })
                //                    )
                //                }}
                    .environmentObject(PushChatRoomRouteManager.shared) // 푸시알람 채팅방 이동
            }
        }
    }
    
    
    class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
        func application(_ application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            FirebaseApp.configure()
            // Firebase 실행확인 print
            print("Configured Firebase!")
            
            //채팅방 이동
            UNUserNotificationCenter.current().delegate = self
            
            // 푸시 알림을 위한 사용자 동의 요청
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]){ granted, error in
                print("부여된 권한 : \(granted)")
                guard granted else { return }
                DispatchQueue.main.async{
                    application.registerForRemoteNotifications()
                }
            }
            return true
        }
        
        // APNS 토큰을 받았을 때 호출되는 메소드
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            // Firebase에 APNS 토큰 설정
            Messaging.messaging().apnsToken = deviceToken
        }
        
        // APNS 등록 실패 시 호출되는 메소드
        func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            print("Failed to register for remote notifications: \(error.localizedDescription)")
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    didReceive response: UNNotificationResponse,
                                    withCompletionHandler completionHandler: @escaping () -> Void) {
            //Push알림에서 보낸 data 가져오기
            let userInfo = response.notification.request.content.userInfo

            if let chatRoomId = userInfo["chatRoomId"] as? String, //채팅방 id
               let userId = userInfo["userId"] as? String, //유저 id
               let partnerId = userInfo["partnerId"] as? String,//상대방 유저 id
               let noticeBoardId = userInfo["noticeBoardId"] as? String,// 게시물 Id
               let noticeBoardTitle = userInfo["noticeBoardTitle"] as? String,// 게시물 제목
               let nickname = userInfo["nickname"] as? String,// 상대방 닉네임
               let style = userInfo["style"] as? String, // 칭호
               let profileURL = userInfo["profileURL"] as? String {
                // 채팅방 상태 업데이트
                PushChatRoomRouteManager.shared.navigateToChatRoom(chatRoomId: chatRoomId, userId: userId,  partnerId: partnerId, noticeBoardTitle: noticeBoardTitle, noticeBoardId: noticeBoardId, nickname: nickname, style: style, profileURL: profileURL)

            }
            completionHandler()
        }

    }
}
