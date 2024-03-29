//
//  LoginGoogle.swift
//  BookBridge
//
//  Created by 이민호 on 1/25/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct GoogleLoginView: View {
    @StateObject private var viewModel = GoogleAuthViewModel()
    @Binding var showingLoginView: Bool
    
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
        .onChange(of: viewModel.isLogin) { newState in
            if newState {
                showingLoginView.toggle()
            }
        }
    }    
}
