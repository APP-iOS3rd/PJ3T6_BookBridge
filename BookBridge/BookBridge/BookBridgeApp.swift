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
                    .environmentObject(AppState.shared) // 푸시알람 채팅방 이동
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
            let userInfo = response.notification.request.content.userInfo
            if let chatRoomId = userInfo["chatRoomId"] as? String {
                print("chatRoomId : \(chatRoomId)")

                // 알림에 포함된 chatRoomID를 처리
                navigateToChatRoom(with: chatRoomId)
            }
            completionHandler()
        }
        
        private func navigateToChatRoom(with chatRoomId: String) {
            // 앱의 상태 또는 뷰 모델을 업데이트하여, 채팅룸 이동
            AppState.shared.navigateToChatRoom(chatRoomId)
        }
    }
}
// 푸시알람 채팅방 이동
class AppState: ObservableObject {
    static let shared = AppState()
    @Published var selectedChatRoomID: String?
    
    func navigateToChatRoom(_ chatRoomID: String) {
        self.selectedChatRoomID = chatRoomID
        // 추가적인 로직 (뷰 전환등 추가로직 필요할것같음)
    }
}
