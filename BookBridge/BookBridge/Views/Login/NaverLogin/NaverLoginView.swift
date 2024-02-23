//
//  NaverLoginView.swift
//  BookBridge
//
//  Created by 노주영 on 1/29/24.
//

import SwiftUI
import NaverThirdPartyLogin

struct NaverLoginView: View {
    @StateObject var naverLoginManger = NaverAuthManager.shared
    @Binding var showingLoginView: Bool
    
    var body: some View {
        VStack {
            Button{
                naverLoginManger.doNaverLogin()
            } label: {
                Image("naverLogo")
                    .resizable()
                    .frame(width: 36, height: 36)
            }
        }.onChange(of: naverLoginManger.isLogin) { _ in
            showingLoginView.toggle()            
        }
        
    }
}

