//
//  KakaoLoginView.swift
//  BookBridge
//
//  Created by 김건호 on 1/26/24.
//

import SwiftUI

struct KakaoLoginView: View {
    @StateObject private var viewModel = KakaoLoginViewModel()
    @EnvironmentObject private var pathModel: PathViewModel
    @Binding var showingLoginView: Bool
    
    var body: some View {
        VStack {
            if viewModel.state == .signedOut {
                Button(action: {
                    viewModel.kakaoAuthSignIn()
                }
                ) {
                    ZStack {
                        Image("KaKaoLogo")
                            .resizable()
                            .frame(width: 36, height: 36)
                    }
                }
            } else {
                KakaoLoginStatusView(viewModel: viewModel)
            }
        }.onChange(of: viewModel.state) { newState in
            if newState == .signedIn {
                UserManager.shared.isLogin = true
                UserManager.shared.setUser(uid: viewModel.userId!)
                showingLoginView = false
            }
        }
        
    }
}

struct KakaoLoginStatusView: View {
    @ObservedObject var viewModel: KakaoLoginViewModel
    
    var body: some View {
        Button(action: viewModel.logout) {
            Text("로그아웃")
                .foregroundColor(.white)
                .padding()
                .background(Color.yellow)
                .cornerRadius(5)
        }
    }
}

//
//#Preview {
//    KakaoLoginView()
//}
