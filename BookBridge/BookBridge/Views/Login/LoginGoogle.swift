//
//  LoginGoogle.swift
//  BookBridge
//
//  Created by 이민호 on 1/25/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignResultModel {
    let idToken: String
    let accessToken: String
}

final class AuthenticationViewModel: ObservableObject {
    func signInGoogle() async throws {
        guard let topVC = await Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken: String = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        let accessToken = gidSignInResult.user.accessToken.tokenString
        let tokens = GoogleSignResultModel(idToken: idToken, accessToken: accessToken)
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
    }
}

struct LoginGoogle: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    
    var body: some View {
        
        Button {
            Task {
                do {
                    try await viewModel.signInGoogle()
                } catch {
                    print(error)
                }
            }
        } label: {
             Text("Sign in with google")
        }
    }
}

#Preview {
    LoginGoogle()
}
