//
//  NaverLoginView.swift
//  BookBridge
//
//  Created by 노주영 on 1/29/24.
//

import SwiftUI
import NaverThirdPartyLogin

struct NaverLoginView: View {
    @StateObject private var viewModel = NaverLoginViewModel()
    
    private var naverLoginManger = NaverLoginManager.shared
    
    var body: some View {
        VStack {
            if viewModel.isLogin {
                Button{
                    naverLoginManger.doNaverLogout()
                    viewModel.isLogin = false
                } label: {
                    Image("googleLogo")
                        .resizable()
                        .frame(width: 36, height: 36)
                }
            } else {
                Button{
                    naverLoginManger.doNaverLogin()
                    viewModel.isLogin = true
                } label: {
                    Image("naverLogo")
                        .resizable()
                        .frame(width: 36, height: 36)
                }
            }
        }
    }
}

#Preview {
    NaverLoginView()
}
