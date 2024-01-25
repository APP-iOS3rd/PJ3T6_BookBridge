//
//  BookBridgeApp.swift
//  BookBridge
//
//  Created by 이민호 on 1/25/24.
//

import SwiftUI
import Firebase

@main
struct BookBridgeApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            LoginGoogleView()
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
