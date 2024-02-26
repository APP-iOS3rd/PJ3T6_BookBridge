//
//  AppleLoginView.swift
//
//  1. Apple 인증완료시 appleAuthManager.isSignedIn ture
//  2. onChange에서 isSignedIn 관찰
//  3. showingLoginView 를 false로 변경함으로서 TabBarView로 돌아감
//  Created by 김지훈 on 2024/01/30.
//


import SwiftUI
import AuthenticationServices

struct AppleLoginView: View {
    @StateObject private var appleAuthManager = AppleAuthManager()
    @Binding var showingLoginView: Bool

    var body: some View {
        VStack {
                Button(action: appleAuthManager.startSignInWithAppleFlow) {
                    ZStack {
                        Image("AppleLogo")
                            .resizable()
                            .frame(width: 39, height: 39)
                            .clipShape(Circle())
                    }
                }

            
        }
        .onChange(of: appleAuthManager.isSignedIn){ result in
            if result{
                // 로그인 성공
                showingLoginView = false
            }
        }
    }

}
