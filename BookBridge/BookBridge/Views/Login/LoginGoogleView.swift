//
//  LoginGoogle.swift
//  BookBridge
//
//  Created by 이민호 on 1/25/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

final class AuthenticationViewModel: ObservableObject {
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
    }
    
}

struct LoginGoogleView: View {
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
            ZStack {
                Image("googleLogo")
                    .resizable()
                    .frame(width: 18, height: 18)
                
                Circle()
                    .stroke(Color(hex: "D9D9D9"))
                    .frame(width: 39)
                    .foregroundColor(.white)
            }
        }
        
    }
}

#Preview {
    LoginGoogleView()
}
