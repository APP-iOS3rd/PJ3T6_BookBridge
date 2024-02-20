//
//  NaverLoginView.swift
//  BookBridge
//
//  Created by 노주영 on 1/29/24.
//

import SwiftUI
import NaverThirdPartyLogin

struct NaverLoginView: View {
    @State private var isLogin: Bool = false
    
    private var naverLoginManger = NaverAuthManager.shared
    
    var body: some View {
        VStack {
            if isLogin {
                //TODO: 로그인시 화면 이동 (지금은 구현 상태 확인용으로 로그아웃 넣어놓음)
                Button{
                    naverLoginManger.doNaverLogout()
                    isLogin = false
                } label: {
                    Image("naverLogo")
                        .resizable()
                        .frame(width: 36, height: 36)
                }
            } else {
                Button{
                    naverLoginManger.doNaverLogin()
                    isLogin = true
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
