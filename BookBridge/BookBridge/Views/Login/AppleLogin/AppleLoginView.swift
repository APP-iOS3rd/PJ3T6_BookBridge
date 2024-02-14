//
//  AppleLoginView.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/01/30.
//


import SwiftUI
import AuthenticationServices

struct AppleLoginView: View {
    @StateObject private var appleAuthManager = AppleAuthManager()

    var body: some View {
        VStack {
            if appleAuthManager.isSignedIn {
                Text("Apple로그인 성공~")
//                HomeView(user: user)
            } else {
                Button(action: appleAuthManager.startSignInWithAppleFlow) {
                    ZStack {
                        Image("AppleLogo")
                            .resizable()
                            .frame(width: 39, height: 39)
                            .clipShape(Circle())
                    }
                }

            }
        }
        .onAppear {
            appleAuthManager.didChangeSignInStatus = { signedIn in
                if signedIn {
                    // 로그인 성공
                } else {
                    // 로그인 실패
                }
            }
        }


    }

}
