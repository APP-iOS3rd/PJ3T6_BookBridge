//
//  AppleLoginView.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/01/30.
//


import SwiftUI
import AuthenticationServices

struct AppleLoginView: View {
    var appleAuthManager = AppleAuthManager()
    @State private var isSignedIn = false
    @State private var currentUser: UserModel?

    var body: some View {
        VStack {
            if isSignedIn, let user = currentUser {
                Text("Apple로그인 성공~")
//                HomeView(user: user)
            } else {
                Button(action: startAppleSignIn) {
                    ZStack {
                        Image("AppleLogo")
                            .resizable()
                            .frame(width: 39, height: 39)
                            .clipShape(Circle())
                    }
                }
//                .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
//                .cornerRadius(5)
            }
        }

    }

    private func startAppleSignIn() {
        
        appleAuthManager.didChangeSignInStatus = { signedIn, user in
            self.isSignedIn = signedIn
            self.currentUser = user
        }
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = appleAuthManager
        controller.performRequests()
    }
}
